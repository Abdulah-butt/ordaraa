import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../domain/usecases/logout_use_case.dart';
import '../../service_locator/service_locator.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import '../api_endpoint.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorageService, Dio dio)
    : _dio = dio,
      _refreshDio = Dio(
        BaseOptions(
          baseUrl: dio.options.baseUrl,
          connectTimeout: dio.options.connectTimeout,
          receiveTimeout: dio.options.receiveTimeout,
          sendTimeout: dio.options.sendTimeout,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  static const _retriedRequestKey = 'auth_request_retried';

  final Dio _dio;
  final Dio _refreshDio;
  final SecureStorageService _secureStorageService;
  Future<_AuthTokens>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isRefreshRequest(options)) {
      final accessToken = await _secureStorageService.getAccessToken();
      if (accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRefresh(err)) {
      handler.next(err);
      return;
    }

    try {
      final failedAccessToken = _bearerToken(
        err.requestOptions.headers['Authorization'],
      );
      final storedAccessToken = await _secureStorageService.getAccessToken();

      // Another request may already have completed token rotation.
      final accessToken =
          storedAccessToken.isNotEmpty && failedAccessToken != storedAccessToken
          ? storedAccessToken
          : (await _refreshSession()).accessToken;

      final response = await _retry(err.requestOptions, accessToken);
      handler.resolve(response);
    } catch (error, stackTrace) {
      log(
        'Authentication session refresh failed.',
        error: error,
        stackTrace: stackTrace,
      );
      await _expireSession();
      handler.reject(err);
    }
  }

  bool _shouldRefresh(DioException error) {
    final options = error.requestOptions;
    if (_isRefreshRequest(options) ||
        options.extra[_retriedRequestKey] == true) {
      return false;
    }

    final response = error.response;
    final errorBody = response?.data;
    final errorResource = errorBody is Map ? errorBody['error'] : null;
    final errorCode = errorResource is Map ? errorResource['code'] : null;
    return response?.statusCode == 401 && errorCode == 'TOKEN_EXPIRED';
  }

  bool _isRefreshRequest(RequestOptions options) =>
      options.path.endsWith(APIEndpoint.refreshAuthSession);

  Future<_AuthTokens> _refreshSession() async {
    final activeRefresh = _refreshFuture;
    if (activeRefresh != null) return activeRefresh;

    final refresh = _performRefresh();
    _refreshFuture = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_refreshFuture, refresh)) _refreshFuture = null;
    }
  }

  Future<_AuthTokens> _performRefresh() async {
    final refreshToken = await _secureStorageService.getRefreshToken();
    if (refreshToken.isEmpty) {
      throw const FormatException('No refresh token is available.');
    }

    final response = await _refreshDio.post<Map<String, dynamic>>(
      APIEndpoint.refreshAuthSession,
      data: {'refreshToken': refreshToken},
    );
    final data = response.data?['data'];
    final session = data is Map ? data['session'] : null;
    final accessToken = session is Map ? session['accessToken'] : null;
    final rotatedRefreshToken = session is Map ? session['refreshToken'] : null;
    if (accessToken is! String ||
        accessToken.isEmpty ||
        rotatedRefreshToken is! String ||
        rotatedRefreshToken.isEmpty) {
      throw const FormatException(
        'The refresh response contains no valid session.',
      );
    }

    await _secureStorageService.saveAuthTokens(
      accessToken: accessToken,
      refreshToken: rotatedRefreshToken,
    );
    return _AuthTokens(accessToken: accessToken);
  }

  Future<Response<dynamic>> _retry(
    RequestOptions failedRequest,
    String accessToken,
  ) {
    final data = failedRequest.data;
    return _dio.fetch<dynamic>(
      failedRequest.copyWith(
        data: data is FormData ? data.clone() : data,
        headers: {
          ...failedRequest.headers,
          'Authorization': 'Bearer $accessToken',
        },
        extra: {...failedRequest.extra, _retriedRequestKey: true},
      ),
    );
  }

  String? _bearerToken(Object? authorization) {
    if (authorization is! String || !authorization.startsWith('Bearer ')) {
      return null;
    }
    return authorization.substring('Bearer '.length);
  }

  Future<void> _expireSession() async {
    if (getIt.isRegistered<LogoutUseCase>()) {
      await getIt<LogoutUseCase>().execute();
      return;
    }
    await _secureStorageService.clearAuthTokens();
  }
}

class _AuthTokens {
  const _AuthTokens({required this.accessToken});

  final String accessToken;
}
