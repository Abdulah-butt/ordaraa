import '../../network/request_model/update_organization_profile_request.dart';
import '../entities/organization.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class UpdateOrganizationProfileUseCase {
  const UpdateOrganizationProfileUseCase(
    this._remoteDatabaseRepository,
    this._userStore,
  );

  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final UserStore _userStore;

  Future<Organization> execute({
    required UpdateOrganizationProfileRequest request,
  }) async {
    final updated = await _remoteDatabaseRepository.updateCurrentOrganization(
      request: request,
    );
    final existing = _userStore.state.memberships
        .where((item) => item.organization.id == updated.id)
        .firstOrNull
        ?.organization;
    final merged = updated.copyWith(
      addresses: updated.addresses.isEmpty
          ? existing?.addresses ?? const []
          : updated.addresses,
    );
    _userStore.updateOrganization(merged);
    return merged;
  }
}
