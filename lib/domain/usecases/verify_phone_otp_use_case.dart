import '../../core/enums/membership_status.dart';
import '../../core/enums/organization_type.dart';
import '../../network/request_model/verify_phone_otp_request.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import '../entities/auth_result.dart';
import '../repositories/database/local_database_repository.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class VerifyPhoneOtpUseCase {
  const VerifyPhoneOtpUseCase(
    this._remoteDatabaseRepository,
    this._secureStorageService,
    this._userStore,
    this._localDatabaseRepository,
  );

  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final SecureStorageService _secureStorageService;
  final UserStore _userStore;
  final LocalDatabaseRepository _localDatabaseRepository;

  Future<AuthResult> execute({
    required VerifyPhoneOtpRequest request,
    required OrganizationType organizationType,
  }) async {
    final result = await _remoteDatabaseRepository.verifyPhoneOtp(
      request: request,
    );
    final session = result.session;
    await _secureStorageService.saveAuthTokens(
      accessToken: session!.accessToken,
      refreshToken: session.refreshToken,
    );
    _userStore.updateAuthUser(result);
    await _persistOrganizationContext(result, organizationType);
    return result;
  }

  Future<void> _persistOrganizationContext(
    AuthResult result,
    OrganizationType organizationType,
  ) async {
    final organizationMembership = result.memberships
        .where(
          (item) =>
              item.membership.status == MembershipStatus.active &&
              (item.organization.type == organizationType ||
                  item.organization.type == OrganizationType.both),
        )
        .firstOrNull;
    if (organizationMembership == null) {
      await _localDatabaseRepository.clearSelectedOrganizationId();
      return;
    }
    await _localDatabaseRepository.saveSelectedOrganizationId(
      organizationMembership.organization.id,
    );
  }
}
