import '../../network/request_model/organization_listing_request.dart';
import '../entities/organization.dart';
import '../entities/paginated_result.dart';
import '../repositories/database/remote_database_repository.dart';

class GetOrganizationsUseCase {
  const GetOrganizationsUseCase(this._remoteDatabaseRepository);

  final RemoteDatabaseRepository _remoteDatabaseRepository;

  Future<PaginatedResult<Organization>> execute({
    required OrganizationListingRequest request,
  }) {
    return _remoteDatabaseRepository.getOrganizations(request: request);
  }
}
