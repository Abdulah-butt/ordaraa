import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/auth_flow_destination.dart';
import 'package:ordaraa/core/enums/user_role.dart';
import 'package:ordaraa/domain/entities/auth_result.dart';
import 'package:ordaraa/domain/entities/auth_session.dart';
import 'package:ordaraa/domain/repositories/database/local_database_repository.dart';
import 'package:ordaraa/domain/repositories/database/remote_database_repository.dart';
import 'package:ordaraa/domain/stores/user_store.dart';
import 'package:ordaraa/domain/usecases/resolve_auth_flow_destination_use_case.dart';
import 'package:ordaraa/domain/usecases/verify_phone_otp_use_case.dart';
import 'package:ordaraa/network/request_model/verify_phone_otp_request.dart';
import 'package:ordaraa/services/secure_storage/secure_storage_service.dart';

void main() {
  test(
    'verification persists tokens and intended role before onboarding',
    () async {
      final authResult = AuthResult(
        session: const AuthSession(
          accessToken: 'access-token',
          refreshToken: 'refresh-token',
          expiresIn: 3600,
          tokenType: 'bearer',
        ),
      );
      final storage = _VerificationStorage();
      final localDatabase = _VerificationLocalDatabase();
      final userStore = UserStore();
      final useCase = VerifyPhoneOtpUseCase(
        _VerificationRepository(authResult),
        storage,
        userStore,
        ResolveAuthFlowDestinationUseCase(storage, localDatabase),
      );

      final destination = await useCase.execute(
        request: const VerifyPhoneOtpRequest(
          phoneNumber: '+61412345678',
          otp: '123456',
        ),
        intendedRole: UserRole.buyer,
      );

      expect(destination, AuthFlowDestination.buyerRegistration);
      expect(storage.accessToken, 'access-token');
      expect(storage.refreshToken, 'refresh-token');
      expect(storage.intendedRole, UserRole.buyer);
      expect(userStore.state, authResult);
      expect(localDatabase.organizationId, isNull);
    },
  );
}

class _VerificationRepository implements RemoteDatabaseRepository {
  _VerificationRepository(this.result);

  final AuthResult result;

  @override
  Future<AuthResult> verifyPhoneOtp({
    required VerifyPhoneOtpRequest request,
  }) async {
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _VerificationStorage implements SecureStorageService {
  String accessToken = '';
  String refreshToken = '';
  UserRole? intendedRole;

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> saveIntendedUserRole(UserRole role) async {
    intendedRole = role;
  }

  @override
  Future<UserRole?> getIntendedUserRole() async => intendedRole;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _VerificationLocalDatabase implements LocalDatabaseRepository {
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
