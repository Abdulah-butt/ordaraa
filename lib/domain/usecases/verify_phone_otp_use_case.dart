import '../../core/enums/auth_flow_destination.dart';
import '../../core/enums/user_role.dart';
import '../../network/request_model/verify_phone_otp_request.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';
import 'resolve_auth_flow_destination_use_case.dart';

class VerifyPhoneOtpUseCase {
  const VerifyPhoneOtpUseCase(
    this._remoteDatabaseRepository,
    this._secureStorageService,
    this._userStore,
    this._resolveAuthFlowDestinationUseCase,
  );

  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final SecureStorageService _secureStorageService;
  final UserStore _userStore;
  final ResolveAuthFlowDestinationUseCase _resolveAuthFlowDestinationUseCase;

  Future<AuthFlowDestination> execute({
    required VerifyPhoneOtpRequest request,
    required UserRole intendedRole,
  }) async {
    final result = await _remoteDatabaseRepository.verifyPhoneOtp(
      request: request,
    );
    final session = result.session;
    await Future.wait([
      _secureStorageService.saveAuthTokens(
        accessToken: session!.accessToken,
        refreshToken: session.refreshToken,
      ),
      _secureStorageService.saveIntendedUserRole(intendedRole),
    ]);
    _userStore.updateAuthUser(result);
    return _resolveAuthFlowDestinationUseCase.execute(
      authResult: result,
      intendedRole: intendedRole,
    );
  }
}
