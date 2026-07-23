import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/interceptors/auth_interceptor.dart';
import 'package:ordaraa/services/secure_storage/secure_storage_service.dart';

void main() {
  group('AuthInterceptor', () {
    test('adds the stored access token to requests', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
      );
      late String? authorization;
      final harness = _Harness(
        storage: storage,
        handler: (options) {
          authorization = options.headers['Authorization'] as String?;
          return _jsonResponse(200, {
            'data': {'ok': true},
          });
        },
      );
      addTearDown(harness.close);

      await harness.dio.get<dynamic>('/resource');

      expect(authorization, 'Bearer access-old');
    });

    test('refreshes, rotates tokens, and replays the failed request', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
      );
      var refreshCalls = 0;
      var resourceCalls = 0;
      final harness = _Harness(
        storage: storage,
        handler: (options) {
          if (options.path.endsWith(APIEndpoint.refreshAuthSession)) {
            refreshCalls++;
            expect(options.data, {'refreshToken': 'refresh-old'});
            return _jsonResponse(200, _refreshResponse);
          }
          resourceCalls++;
          final authorization = options.headers['Authorization'];
          if (authorization == 'Bearer access-new') {
            return _jsonResponse(200, {
              'data': {'ok': true},
            });
          }
          return _tokenExpiredResponse();
        },
      );
      addTearDown(harness.close);

      final response = await harness.dio.get<Map<String, dynamic>>('/resource');

      expect(response.data?['data'], {'ok': true});
      expect(refreshCalls, 1);
      expect(resourceCalls, 2);
      expect(storage.accessToken, 'access-new');
      expect(storage.refreshToken, 'refresh-new');
      expect(storage.savePairCalls, 1);
    });

    test('uses one refresh for concurrent expired requests', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
      );
      var refreshCalls = 0;
      final harness = _Harness(
        storage: storage,
        handler: (options) async {
          if (options.path.endsWith(APIEndpoint.refreshAuthSession)) {
            refreshCalls++;
            await Future<void>.delayed(const Duration(milliseconds: 20));
            return _jsonResponse(200, _refreshResponse);
          }
          if (options.headers['Authorization'] == 'Bearer access-new') {
            return _jsonResponse(200, {
              'data': {'ok': true},
            });
          }
          return _tokenExpiredResponse();
        },
      );
      addTearDown(harness.close);

      final responses = await Future.wait([
        harness.dio.get<dynamic>('/resource/1'),
        harness.dio.get<dynamic>('/resource/2'),
        harness.dio.get<dynamic>('/resource/3'),
        harness.dio.get<dynamic>('/resource/4'),
      ]);

      expect(responses, hasLength(4));
      expect(refreshCalls, 1);
      expect(storage.savePairCalls, 1);
    });

    test('expires the session when the refresh token is rejected', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-invalid',
      );
      var expirationCalls = 0;
      final harness = _Harness(
        storage: storage,
        onSessionExpired: () async {
          expirationCalls++;
          await storage.clearAuthTokens();
        },
        handler: (options) {
          if (options.path.endsWith(APIEndpoint.refreshAuthSession)) {
            return _jsonResponse(401, {
              'message': 'Invalid refresh token.',
              'error': {'code': 'UNAUTHORIZED'},
            });
          }
          return _tokenExpiredResponse();
        },
      );
      addTearDown(harness.close);

      final error = await _dioErrorFrom(harness.dio.get<dynamic>('/resource'));

      expect(error.error, isA<AuthSessionExpiredException>());
      expect(expirationCalls, 1);
      expect(storage.accessToken, isEmpty);
      expect(storage.refreshToken, isEmpty);
    });

    test('expires the session once for concurrent refresh rejection', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-invalid',
      );
      var refreshCalls = 0;
      var expirationCalls = 0;
      final harness = _Harness(
        storage: storage,
        onSessionExpired: () async {
          expirationCalls++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          await storage.clearAuthTokens();
        },
        handler: (options) async {
          if (options.path.endsWith(APIEndpoint.refreshAuthSession)) {
            refreshCalls++;
            await Future<void>.delayed(const Duration(milliseconds: 20));
            return _jsonResponse(401, {
              'message': 'Invalid refresh token.',
              'error': {'code': 'UNAUTHORIZED'},
            });
          }
          return _tokenExpiredResponse();
        },
      );
      addTearDown(harness.close);

      final errors = await Future.wait([
        _dioErrorFrom(harness.dio.get<dynamic>('/resource/1')),
        _dioErrorFrom(harness.dio.get<dynamic>('/resource/2')),
        _dioErrorFrom(harness.dio.get<dynamic>('/resource/3')),
      ]);

      expect(
        errors.every((error) => error.error is AuthSessionExpiredException),
        isTrue,
      );
      expect(refreshCalls, 1);
      expect(expirationCalls, 1);
    });

    test('does not clear tokens for a transient refresh failure', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
      );
      var expirationCalls = 0;
      final harness = _Harness(
        storage: storage,
        onSessionExpired: () async => expirationCalls++,
        handler: (options) {
          if (options.path.endsWith(APIEndpoint.refreshAuthSession)) {
            return _jsonResponse(503, {'message': 'Temporarily unavailable'});
          }
          return _tokenExpiredResponse();
        },
      );
      addTearDown(harness.close);

      final error = await _dioErrorFrom(harness.dio.get<dynamic>('/resource'));

      expect(error.response?.statusCode, 503);
      expect(expirationCalls, 0);
      expect(storage.accessToken, 'access-old');
      expect(storage.refreshToken, 'refresh-old');
    });

    test('never refreshes a replayed request more than once', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
      );
      var refreshCalls = 0;
      final harness = _Harness(
        storage: storage,
        handler: (options) {
          if (options.path.endsWith(APIEndpoint.refreshAuthSession)) {
            refreshCalls++;
            return _jsonResponse(200, _refreshResponse);
          }
          return _tokenExpiredResponse();
        },
      );
      addTearDown(harness.close);

      final error = await _dioErrorFrom(harness.dio.get<dynamic>('/resource'));

      expect(error.response?.statusCode, 401);
      expect(refreshCalls, 1);
    });

    test('expires the session when no refresh token exists', () async {
      final storage = _FakeSecureStorage(accessToken: 'access-old');
      var expirationCalls = 0;
      final harness = _Harness(
        storage: storage,
        onSessionExpired: () async {
          expirationCalls++;
          await storage.clearAuthTokens();
        },
        handler: (_) => _tokenExpiredResponse(),
      );
      addTearDown(harness.close);

      final error = await _dioErrorFrom(harness.dio.get<dynamic>('/resource'));

      expect(error.error, isA<AuthSessionExpiredException>());
      expect(expirationCalls, 1);
    });
  });
}

const _refreshResponse = {
  'data': {
    'session': {
      'accessToken': 'access-new',
      'refreshToken': 'refresh-new',
      'expiresIn': 3600,
      'tokenType': 'bearer',
    },
    'user': null,
    'memberships': <dynamic>[],
  },
};

Future<DioException> _dioErrorFrom(Future<dynamic> request) async {
  try {
    await request;
    fail('Expected the request to throw a DioException.');
  } on DioException catch (error) {
    return error;
  }
}

ResponseBody _tokenExpiredResponse() => _jsonResponse(401, {
  'message': 'The access token has expired.',
  'error': {
    'code': 'TOKEN_EXPIRED',
    'message': 'The access token has expired.',
  },
});

ResponseBody _jsonResponse(int statusCode, Object body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

typedef _RequestHandler =
    FutureOr<ResponseBody> Function(RequestOptions options);

class _Harness {
  _Harness({
    required SecureStorageService storage,
    required _RequestHandler handler,
    Future<void> Function()? onSessionExpired,
  }) : dio = Dio(BaseOptions(baseUrl: 'https://ordara.test')),
       refreshDio = Dio(BaseOptions(baseUrl: 'https://ordara.test')) {
    final adapter = _ScriptedAdapter(handler);
    dio.httpClientAdapter = adapter;
    refreshDio.httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        storage,
        dio,
        refreshDio: refreshDio,
        onSessionExpired: onSessionExpired,
      ),
    );
  }

  final Dio dio;
  final Dio refreshDio;

  void close() {
    dio.close(force: true);
    refreshDio.close(force: true);
  }
}

class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.handler);

  final _RequestHandler handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

class _FakeSecureStorage implements SecureStorageService {
  _FakeSecureStorage({this.accessToken = '', this.refreshToken = ''});

  String accessToken;
  String refreshToken;
  int savePairCalls = 0;

  @override
  Future<void> clearAuthTokens() async {
    accessToken = '';
    refreshToken = '';
  }

  @override
  Future<String> getAccessToken() async => accessToken;

  @override
  Future<String> getRefreshToken() async => refreshToken;

  @override
  Future<void> saveAccessToken(String token) async {
    accessToken = token;
  }

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    savePairCalls++;
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    refreshToken = token;
  }
}
