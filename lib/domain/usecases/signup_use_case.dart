import '../../network/request_model/create_account_request.dart';
import '../entities/app_user.dart';
import '../repositories/database/local_database_repository.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class SignupUseCase {
  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final LocalDatabaseRepository _localDatabaseRepository;
  final UserStore _userStore;

  SignupUseCase(this._remoteDatabaseRepository, this._localDatabaseRepository,
      this._userStore);

  Future<void> execute({required CreateAccountRequest request}) async {
    AppUser user =
    await _remoteDatabaseRepository.createAccount(request: request);
    await _localDatabaseRepository.saveAccessToken(user.token!);
    _userStore.updateUser(user);
  }
}
