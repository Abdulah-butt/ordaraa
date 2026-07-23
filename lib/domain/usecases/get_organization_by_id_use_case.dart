import '../entities/organization.dart';
import '../repositories/database/remote_database_repository.dart';

class GetOrganizationByIdUseCase {
  const GetOrganizationByIdUseCase(this._remoteDatabaseRepository);

  final RemoteDatabaseRepository _remoteDatabaseRepository;

  Future<Organization> execute({required String id}) {
    return _remoteDatabaseRepository.getOrganizationById(id: id);
  }
}
