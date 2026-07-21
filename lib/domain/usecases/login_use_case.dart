import '../../network/request_model/login_request.dart';
import '../entities/app_user.dart';
import '../repositories/database/local_database_repository.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class LoginUseCase {
  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final LocalDatabaseRepository _localDatabaseRepository;
  final UserStore _userStore;

  LoginUseCase(
    this._remoteDatabaseRepository,
    this._localDatabaseRepository,
    this._userStore,
  );

  Future<void> execute({required LoginRequest request}) async {
    AppUser user = await _remoteDatabaseRepository.login(request: request);
    await _localDatabaseRepository.saveAccessToken(user.token!);
    _userStore.updateUser(user);
  }
}
