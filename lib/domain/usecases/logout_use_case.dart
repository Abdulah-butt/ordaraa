import '../../services/secure_storage/secure_storage_service.dart';
import '../repositories/database/local_database_repository.dart';
import '../stores/user_store.dart';

class LogoutUseCase {
  final SecureStorageService _secureStorageService;
  final UserStore _userStore;
  final LocalDatabaseRepository _localDatabaseRepository;

  LogoutUseCase(
    this._secureStorageService,
    this._userStore,
    this._localDatabaseRepository,
  );

  Future<void> execute() async {
    await Future.wait([
      _secureStorageService.clearAuthTokens(),
      _localDatabaseRepository.clearSelectedOrganizationId(),
    ]);
    _userStore.logoutUser();
  }
}
