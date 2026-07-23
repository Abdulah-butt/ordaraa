import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/domain/entities/auth_result.dart';
import 'package:ordaraa/domain/repositories/database/remote_database_repository.dart';
import 'package:ordaraa/domain/stores/user_store.dart';
import 'package:ordaraa/domain/usecases/user_login_session_use_case.dart';
import 'package:ordaraa/network/interceptors/auth_interceptor.dart';
import 'package:ordaraa/services/secure_storage/secure_storage_service.dart';

void main() {
  group('UserLoginSessionUseCase', () {
    test(
      'returns false without calling profile when no token exists',
      () async {
        final repository = _SessionRepository();
        final useCase = UserLoginSessionUseCase(
          repository,
          _SessionStorage(),
          UserStore(),
        );

        expect(await useCase.execute(), isFalse);
        expect(repository.profileCalls, 0);
      },
    );

    test('returns false when refresh rejection expires the session', () async {
      final repository = _SessionRepository(
        profileError: const AuthSessionExpiredException(),
      );
      final useCase = UserLoginSessionUseCase(
        repository,
        _SessionStorage(accessToken: 'expired-access-token'),
        UserStore(),
      );

      expect(await useCase.execute(), isFalse);
      expect(repository.profileCalls, 1);
    });

    test(
      'returns true and updates the user store for a valid session',
      () async {
        final result = const AuthResult.guest();
        final repository = _SessionRepository(result: result);
        final userStore = UserStore();
        final useCase = UserLoginSessionUseCase(
          repository,
          _SessionStorage(accessToken: 'valid-access-token'),
          userStore,
        );

        expect(await useCase.execute(), isTrue);
        expect(userStore.state, result);
      },
    );
  });
}

class _SessionRepository implements RemoteDatabaseRepository {
  _SessionRepository({this.result, this.profileError});

  final AuthResult? result;
  final Object? profileError;
  int profileCalls = 0;

  @override
  Future<AuthResult> getUserProfile() async {
    profileCalls++;
    final error = profileError;
    if (error != null) throw error;
    return result ?? const AuthResult.guest();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SessionStorage implements SecureStorageService {
  _SessionStorage({this.accessToken = ''});

  String accessToken;
  String refreshToken = '';

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
  Future<void> saveAccessToken(String token) async => accessToken = token;

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> saveRefreshToken(String token) async => refreshToken = token;
}
