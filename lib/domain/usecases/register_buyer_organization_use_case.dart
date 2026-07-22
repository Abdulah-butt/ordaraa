import '../../network/request_model/organization_registration_request.dart';
import '../entities/organization_membership.dart';
import '../repositories/database/local_database_repository.dart';
import '../repositories/database/remote_database_repository.dart';
import '../stores/user_store.dart';

class RegisterBuyerOrganizationUseCase {
  const RegisterBuyerOrganizationUseCase(
    this._remoteDatabaseRepository,
    this._userStore,
    this._localDatabaseRepository,
  );

  final RemoteDatabaseRepository _remoteDatabaseRepository;
  final UserStore _userStore;
  final LocalDatabaseRepository _localDatabaseRepository;

  Future<OrganizationMembership> execute({
    required OrganizationRegistrationRequest request,
  }) async {
    final organizationMembership = await _remoteDatabaseRepository
        .createBuyerOrganization(request: request);
    _userStore.addOrganizationMembership(organizationMembership);
    await _localDatabaseRepository.saveSelectedOrganizationId(
      organizationMembership.organization.id,
    );
    return organizationMembership;
  }
}
