import 'dart:developer';
import 'package:dio/dio.dart';
import '../../domain/repositories/database/local_database_repository.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../service_locator/service_locator.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio; // A separate instance to avoid intercept loop
  final LocalDatabaseRepository _localDatabaseRepository;

  AuthInterceptor(
    this._localDatabaseRepository,
    Dio dio,
  ) : _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _localDatabaseRepository.getAccessToken();
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
    final refreshTokenEndpoint = "";
    final isUnauthorized = err.response?.statusCode == 401;

    /// TODO: ADD REFRESH TOKEN ENDPOINT
    final isRefreshing = err.requestOptions.path.contains(refreshTokenEndpoint);

    if (isUnauthorized && !isRefreshing) {
      try {
        // Attempt to refresh token
        final refreshToken = await _localDatabaseRepository.getRefreshToken();
        if (refreshToken.isEmpty) {
          _onLogout();
          handler.reject(err);
          return;
        }

        final refreshResponse = await _dio.post(
          refreshTokenEndpoint,
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = refreshResponse.data['accessToken'];
        final newRefreshToken = refreshResponse.data['refreshToken'];

        if (newAccessToken != null) {
          await _localDatabaseRepository.saveAccessToken(newAccessToken);
          await _localDatabaseRepository.saveRefreshToken(newRefreshToken);

          // Retry the original request with new token
          final newRequest = err.requestOptions;
          newRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          final response = await _dio.fetch(newRequest);
          handler.resolve(response);
          return;
        } else {
          _onLogout();
          handler.reject(err);
        }
      } catch (e) {
        log('Token refresh failed: $e');
        _onLogout(); // Force logout
        handler.reject(err);
        return;
      }
    }

    handler.next(err);
  }

  void _onLogout() {
    getIt<LogoutUseCase>().execute();
  }
}
