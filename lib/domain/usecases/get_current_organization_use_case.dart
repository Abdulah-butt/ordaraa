import '../entities/organization.dart';
import '../repositories/database/remote_database_repository.dart';

class GetCurrentOrganizationUseCase {
  const GetCurrentOrganizationUseCase(this._remoteDatabaseRepository);

  final RemoteDatabaseRepository _remoteDatabaseRepository;

  Future<Organization> execute() {
    return _remoteDatabaseRepository.getCurrentOrganization();
  }
}
