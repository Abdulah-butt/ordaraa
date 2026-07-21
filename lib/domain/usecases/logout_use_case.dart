import '../repositories/database/local_database_repository.dart';
import '../stores/user_store.dart';

class LogoutUseCase {
  final LocalDatabaseRepository _localDatabaseRepository;
  final UserStore _userStore;

  LogoutUseCase(
    this._localDatabaseRepository,
    this._userStore,
  );

  Future<void> execute() async {
    await _localDatabaseRepository.logoutUser();
    _userStore.logoutUser();
  }
}
