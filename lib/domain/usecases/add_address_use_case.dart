import '../../network/request_model/add_address_request.dart';
import '../entities/address.dart';
import '../repositories/database/remote_database_repository.dart';

class AddAddressUseCase {
  const AddAddressUseCase(this._remoteDatabaseRepository);

  final RemoteDatabaseRepository _remoteDatabaseRepository;

  Future<Address> execute({required AddAddressRequest request}) {
    return _remoteDatabaseRepository.addAddress(request: request);
  }
}
