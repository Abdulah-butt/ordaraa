import '../../network/request_model/update_user_profile_request.dart';
import '../entities/user.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class UpdateUserProfileUseCase {
  const UpdateUserProfileUseCase(
    this._remoteDatabaseRepository,
    this._userStore,
  );

  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final UserStore _userStore;

  Future<User> execute({required UpdateUserProfileRequest request}) async {
    final user = await _remoteDatabaseRepository.updateUserProfile(
      request: request,
    );
    _userStore.updateUser(user);
    return user;
  }
}
