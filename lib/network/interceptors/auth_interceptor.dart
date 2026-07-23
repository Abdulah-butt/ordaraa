import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../domain/usecases/logout_use_case.dart';
import '../../service_locator/service_locator.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import '../api_endpoint.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._secureStorageService,
    Dio dio, {
    Dio? refreshDio,
    this.onSessionExpired,
  }) : _dio = dio,
       _refreshDio =
           refreshDio ??
           Dio(
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
  final Future<void> Function()? onSessionExpired;
  Future<_RefreshResult>? _refreshFuture;
  Future<void>? _expireSessionFuture;
  bool _sessionTerminated = false;
  String? _terminatedAccessToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isRefreshRequest(options)) {
      final accessToken = await _secureStorageService.getAccessToken();
      if (_sessionTerminated &&
          accessToken.isNotEmpty &&
          accessToken != _terminatedAccessToken) {
        _sessionTerminated = false;
        _terminatedAccessToken = null;
      }
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
    if (_sessionTerminated) {
      handler.reject(_sessionExpiredError(err));
      return;
    }

    final failedAccessToken = _bearerToken(
      err.requestOptions.headers['Authorization'],
    );
    try {
      final storedAccessToken = await _secureStorageService.getAccessToken();

      // Another request may already have completed token rotation.
      final accessToken =
          storedAccessToken.isNotEmpty && failedAccessToken != storedAccessToken
          ? storedAccessToken
          : (await _refreshSession()).tokensOrThrow.accessToken;

      final response = await _retry(err.requestOptions, accessToken);
      handler.resolve(response);
    } catch (error, stackTrace) {
      log(
        'Authentication session refresh failed.',
        error: error,
        stackTrace: stackTrace,
      );
      if (_isTerminalRefreshFailure(error)) {
        if (!_sessionTerminated) {
          _sessionTerminated = true;
          _terminatedAccessToken = failedAccessToken;
          await _expireSessionOnce();
        } else {
          final activeExpiration = _expireSessionFuture;
          if (activeExpiration != null) await activeExpiration;
        }
        handler.reject(_sessionExpiredError(err));
        return;
      }
      if (error is DioException) {
        handler.reject(error);
        return;
      }
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          type: DioExceptionType.unknown,
          error: error,
        ),
      );
    }
  }

  DioException _sessionExpiredError(DioException originalError) {
    return DioException(
      requestOptions: originalError.requestOptions,
      response: originalError.response,
      type: DioExceptionType.unknown,
      error: const AuthSessionExpiredException(),
    );
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

  Future<_RefreshResult> _refreshSession() async {
    final activeRefresh = _refreshFuture;
    if (activeRefresh != null) return activeRefresh;

    final refresh = _performRefreshSafely();
    _refreshFuture = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_refreshFuture, refresh)) _refreshFuture = null;
    }
  }

  Future<_RefreshResult> _performRefreshSafely() async {
    try {
      return _RefreshResult.success(await _performRefresh());
    } catch (error, stackTrace) {
      return _RefreshResult.failure(error, stackTrace);
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

  bool _isTerminalRefreshFailure(Object error) {
    if (error is FormatException) return true;
    if (error is! DioException) return false;
    final statusCode = error.response?.statusCode;
    return statusCode == 400 || statusCode == 401 || statusCode == 403;
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

  Future<void> _expireSessionOnce() async {
    final activeExpiration = _expireSessionFuture;
    if (activeExpiration != null) return activeExpiration;

    final expiration = _expireSession();
    _expireSessionFuture = expiration;
    try {
      await expiration;
    } finally {
      if (identical(_expireSessionFuture, expiration)) {
        _expireSessionFuture = null;
      }
    }
  }

  Future<void> _expireSession() async {
    final expirationCallback = onSessionExpired;
    if (expirationCallback != null) {
      await expirationCallback();
      return;
    }
    if (getIt.isRegistered<LogoutUseCase>()) {
      await getIt<LogoutUseCase>().execute();
      return;
    }
    await _secureStorageService.clearAuthTokens();
  }
}

class AuthSessionExpiredException implements Exception {
  const AuthSessionExpiredException();

  @override
  String toString() => 'Your session has expired. Please sign in again.';
}

class _AuthTokens {
  const _AuthTokens({required this.accessToken});

  final String accessToken;
}

class _RefreshResult {
  const _RefreshResult.success(_AuthTokens tokens)
    : _tokens = tokens,
      _error = null,
      _stackTrace = null;

  const _RefreshResult.failure(Object error, StackTrace stackTrace)
    : _tokens = null,
      _error = error,
      _stackTrace = stackTrace;

  final _AuthTokens? _tokens;
  final Object? _error;
  final StackTrace? _stackTrace;

  _AuthTokens get tokensOrThrow {
    final tokens = _tokens;
    if (tokens != null) return tokens;
    Error.throwWithStackTrace(_error!, _stackTrace!);
  }
}
