import '../entities/app_user.dart';
import '../repositories/database/local_database_repository.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class UserLoginSessionUseCase {
  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final LocalDatabaseRepository _localDatabaseRepository;
  final UserStore _userStore;

  UserLoginSessionUseCase(
    this._remoteDatabaseRepository,
    this._localDatabaseRepository,
    this._userStore,
  );

  Future<bool> execute() async {
    String token = await _localDatabaseRepository.getAccessToken();
    if (token.isEmpty) return false;
    AppUser user = await _remoteDatabaseRepository.getUserProfile();
    _userStore.updateUser(user);
    return true;
  }
}
