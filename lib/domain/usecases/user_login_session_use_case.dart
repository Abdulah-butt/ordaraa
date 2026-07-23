import 'package:ordaraa/domain/entities/auth_result.dart';

import '../../core/enums/auth_flow_destination.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import 'resolve_auth_flow_destination_use_case.dart';

class UserLoginSessionUseCase {
  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final SecureStorageService _secureStorageService;
  final UserStore _userStore;
  final ResolveAuthFlowDestinationUseCase _resolveAuthFlowDestinationUseCase;

  UserLoginSessionUseCase(
    this._remoteDatabaseRepository,
    this._secureStorageService,
    this._userStore,
    this._resolveAuthFlowDestinationUseCase,
  );

  Future<AuthFlowDestination> execute() async {
    final token = await _secureStorageService.getAccessToken();
    if (token.isEmpty) return AuthFlowDestination.chooseRole;
    final AuthResult result = await _remoteDatabaseRepository.getUserProfile();
    _userStore.updateAuthUser(result);
    return _resolveAuthFlowDestinationUseCase.execute(authResult: result);
  }
}
