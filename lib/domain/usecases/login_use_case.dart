import '../../network/request_model/login_request.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class LoginUseCase {
  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final SecureStorageService _secureStorageService;
  final UserStore _userStore;

  LoginUseCase(
    this._remoteDatabaseRepository,
    this._secureStorageService,
    this._userStore,
  );

  Future<void> execute({required LoginRequest request}) async {
    // AppUser user = await _remoteDatabaseRepository.login(request: request);
    // final token = user.token;
    // if (token != null && token.isNotEmpty) {
    //   await _secureStorageService.saveAccessToken(token);
    // }
    // _userStore.updateUser(user);
  }
}
