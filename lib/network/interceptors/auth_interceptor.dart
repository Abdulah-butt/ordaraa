import 'package:dio/dio.dart';

import '../../services/secure_storage/secure_storage_service.dart';
import '../api_endpoint.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._secureStorageService,
    this._dio, {
    Dio Function()? refreshDioFactory,
    this._onSessionExpired,
  }) : _refreshDio =
           refreshDioFactory?.call() ??
           Dio(
             BaseOptions(
               baseUrl: _dio.options.baseUrl,
               connectTimeout: _dio.options.connectTimeout,
               receiveTimeout: _dio.options.receiveTimeout,
               sendTimeout: _dio.options.sendTimeout,
             ),
           );

  static const String _retriedKey = 'auth_request_retried';

  final SecureStorageService _secureStorageService;
  final Dio _dio;
  final Dio _refreshDio;
  final Future<void> Function()? _onSessionExpired;
  Future<void>? _sessionExpirationFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _secureStorageService.getAccessToken();

    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    final shouldRefresh =
        err.response?.statusCode == 401 &&
        request.extra[_retriedKey] != true &&
        !request.path.endsWith(APIEndpoint.refreshAuthSession);

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    try {
      final refreshToken = await _secureStorageService.getRefreshToken();
      if (refreshToken.isEmpty) {
        await _expireSession();
        handler.next(err);
        return;
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        APIEndpoint.refreshAuthSession,
        data: {'refreshToken': refreshToken},
      );
      final session = response.data?['data']?['session'];
      final newAccessToken = session?['accessToken'] as String?;
      final newRefreshToken = session?['refreshToken'] as String?;

      if (newAccessToken == null ||
          newAccessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty) {
        await _expireSession();
        handler.next(err);
        return;
      }

      await _secureStorageService.saveAuthTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      final retryResponse = await _dio.fetch(
        request.copyWith(
          data: request.data is FormData
              ? (request.data as FormData).clone()
              : request.data,
          headers: {
            ...request.headers,
            'Authorization': 'Bearer $newAccessToken',
          },
          extra: {...request.extra, _retriedKey: true},
        ),
      );

      handler.resolve(retryResponse);
    } on DioException catch (refreshError) {
      if (refreshError.response?.statusCode case 401 || 403) {
        await _expireSession();
      }
      handler.next(err);
    } catch (_) {
      handler.next(err);
    }
  }

  Future<void> _expireSession() {
    final inProgress = _sessionExpirationFuture;
    if (inProgress != null) return inProgress;

    final expiration = Future<void>.sync(
      () async => _onSessionExpired?.call(),
    ).catchError((_) {});
    _sessionExpirationFuture = expiration;
    return expiration;
  }
}
