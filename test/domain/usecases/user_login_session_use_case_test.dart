import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/auth_flow_destination.dart';
import 'package:ordaraa/core/enums/user_role.dart';
import 'package:ordaraa/domain/entities/auth_result.dart';
import 'package:ordaraa/domain/repositories/database/local_database_repository.dart';
import 'package:ordaraa/domain/repositories/database/remote_database_repository.dart';
import 'package:ordaraa/domain/stores/user_store.dart';
import 'package:ordaraa/domain/usecases/user_login_session_use_case.dart';
import 'package:ordaraa/domain/usecases/resolve_auth_flow_destination_use_case.dart';
import 'package:ordaraa/services/secure_storage/secure_storage_service.dart';

void main() {
  group('UserLoginSessionUseCase', () {
    test(
      'chooses role selection without calling profile when no token exists',
      () async {
        final repository = _SessionRepository();
        final storage = _SessionStorage();
        final localDatabase = _SessionLocalDatabase();
        final useCase = UserLoginSessionUseCase(
          repository,
          storage,
          UserStore(),
          ResolveAuthFlowDestinationUseCase(storage, localDatabase),
        );

        expect(await useCase.execute(), AuthFlowDestination.chooseRole);
        expect(repository.profileCalls, 0);
      },
    );

    test('propagates a profile failure after refresh is rejected', () async {
      final repository = _SessionRepository(profileError: StateError('401'));
      final storage = _SessionStorage(accessToken: 'expired-access-token');
      final useCase = UserLoginSessionUseCase(
        repository,
        storage,
        UserStore(),
        ResolveAuthFlowDestinationUseCase(storage, _SessionLocalDatabase()),
      );

      await expectLater(useCase.execute(), throwsA(isA<StateError>()));
      expect(repository.profileCalls, 1);
    });

    test(
      'resumes buyer registration and updates user store for incomplete setup',
      () async {
        final result = const AuthResult.guest();
        final repository = _SessionRepository(result: result);
        final userStore = UserStore();
        final storage = _SessionStorage(
          accessToken: 'valid-access-token',
          intendedRole: UserRole.buyer,
        );
        final useCase = UserLoginSessionUseCase(
          repository,
          storage,
          userStore,
          ResolveAuthFlowDestinationUseCase(
            storage,
            _SessionLocalDatabase(organizationId: 'stale-id'),
          ),
        );

        expect(await useCase.execute(), AuthFlowDestination.buyerRegistration);
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
  _SessionStorage({this.accessToken = '', this.intendedRole});

  String accessToken;
  String refreshToken = '';
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

  @override
  Future<void> saveIntendedUserRole(UserRole role) async {
    intendedRole = role;
  }
}

class _SessionLocalDatabase implements LocalDatabaseRepository {
  _SessionLocalDatabase({this.organizationId});

  String? organizationId;

  @override
  Future<void> clearSelectedOrganizationId() async => organizationId = null;

  @override
  Future<String?> getSelectedOrganizationId() async => organizationId;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> saveSelectedOrganizationId(String organizationId) async {
    this.organizationId = organizationId;
  }
}
