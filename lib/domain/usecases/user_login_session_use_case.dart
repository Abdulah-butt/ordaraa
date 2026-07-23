import 'package:ordaraa/domain/entities/auth_result.dart';

import '../../network/interceptors/auth_interceptor.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';
import '../../services/secure_storage/secure_storage_service.dart';

class UserLoginSessionUseCase {
  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final SecureStorageService _secureStorageService;
  final UserStore _userStore;

  UserLoginSessionUseCase(
    this._remoteDatabaseRepository,
    this._secureStorageService,
    this._userStore,
  );

  Future<bool> execute() async {
    String token = await _secureStorageService.getAccessToken();
    if (token.isEmpty) return false;
    try {
      final AuthResult result = await _remoteDatabaseRepository
          .getUserProfile();
      _userStore.updateAuthUser(result);
      return true;
    } on AuthSessionExpiredException {
      return false;
    }
  }
}
