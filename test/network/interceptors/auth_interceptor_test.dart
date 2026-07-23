import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/user_role.dart';
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

    test('refreshes and retries each concurrent expired request', () async {
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
      expect(refreshCalls, 4);
      expect(storage.savePairCalls, 4);
    });

    test(
      'expires the local session when the refresh token is rejected',
      () async {
        final storage = _FakeSecureStorage(
          accessToken: 'access-old',
          refreshToken: 'refresh-invalid',
        );
        var sessionExpiredCalls = 0;
        final harness = _Harness(
          storage: storage,
          onSessionExpired: () async {
            sessionExpiredCalls++;
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

        final error = await _dioErrorFrom(
          harness.dio.get<dynamic>('/resource'),
        );

        expect(error.response?.statusCode, 401);
        expect(storage.accessToken, isEmpty);
        expect(storage.refreshToken, isEmpty);
        expect(sessionExpiredCalls, 1);
      },
    );

    test(
      'expires the session once when concurrent refresh requests are rejected',
      () async {
        final storage = _FakeSecureStorage(
          accessToken: 'access-old',
          refreshToken: 'refresh-invalid',
        );
        var refreshCalls = 0;
        var sessionExpiredCalls = 0;
        final harness = _Harness(
          storage: storage,
          onSessionExpired: () async {
            sessionExpiredCalls++;
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
          errors.every((error) => error.response?.statusCode == 401),
          isTrue,
        );
        expect(refreshCalls, 3);
        expect(sessionExpiredCalls, 1);
        expect(storage.accessToken, isEmpty);
        expect(storage.refreshToken, isEmpty);
      },
    );

    test('does not clear tokens for a transient refresh failure', () async {
      final storage = _FakeSecureStorage(
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
      );
      final harness = _Harness(
        storage: storage,
        handler: (options) {
          if (options.path.endsWith(APIEndpoint.refreshAuthSession)) {
            return _jsonResponse(503, {'message': 'Temporarily unavailable'});
          }
          return _tokenExpiredResponse();
        },
      );
      addTearDown(harness.close);

      final error = await _dioErrorFrom(harness.dio.get<dynamic>('/resource'));

      expect(error.response?.statusCode, 401);
      expect(storage.accessToken, 'access-old');
      expect(storage.refreshToken, 'refresh-old');
    });

    test('attempts refresh for any 401 response code', () async {
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
          if (options.headers['Authorization'] == 'Bearer access-new') {
            return _jsonResponse(200, {
              'data': {'ok': true},
            });
          }
          return _jsonResponse(401, {
            'message': 'Unauthorized.',
            'error': {'code': 'UNAUTHORIZED'},
          });
        },
      );
      addTearDown(harness.close);

      final response = await harness.dio.get<dynamic>('/resource');

      expect(response.statusCode, 200);
      expect(refreshCalls, 1);
      expect(storage.accessToken, 'access-new');
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
      var sessionExpiredCalls = 0;
      final harness = _Harness(
        storage: storage,
        onSessionExpired: () async {
          sessionExpiredCalls++;
          await storage.clearAuthTokens();
        },
        handler: (_) => _tokenExpiredResponse(),
      );
      addTearDown(harness.close);

      final error = await _dioErrorFrom(harness.dio.get<dynamic>('/resource'));

      expect(error.response?.statusCode, 401);
      expect(storage.accessToken, isEmpty);
      expect(sessionExpiredCalls, 1);
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
  }) : dio = Dio(BaseOptions(baseUrl: 'https://ordara.test')) {
    final adapter = _ScriptedAdapter(handler);
    dio.httpClientAdapter = adapter;
    dio.interceptors.add(
      AuthInterceptor(
        storage,
        dio,
        refreshDioFactory: () {
          final refreshDio = Dio(BaseOptions(baseUrl: 'https://ordara.test'));
          refreshDio.httpClientAdapter = adapter;
          return refreshDio;
        },
        onSessionExpired: onSessionExpired,
      ),
    );
  }

  final Dio dio;

  void close() {
    dio.close(force: true);
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
  UserRole? intendedRole;

  @override
  Future<void> clearAuthTokens() async {
    accessToken = '';
    refreshToken = '';
    intendedRole = null;
  }

  @override
  Future<String> getAccessToken() async => accessToken;

  @override
  Future<String> getRefreshToken() async => refreshToken;

  @override
  Future<UserRole?> getIntendedUserRole() async => intendedRole;

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

  @override
  Future<void> saveIntendedUserRole(UserRole role) async {
    intendedRole = role;
  }
}
