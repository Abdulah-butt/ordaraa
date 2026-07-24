import '../../network/request_model/update_address_request.dart';
import '../entities/address.dart';
import '../repositories/database/remote_database_repository.dart';

class UpdateAddressUseCase {
  const UpdateAddressUseCase(this._repository);

  final RemoteDatabaseRepository _repository;

  Future<Address> execute({
    required String addressId,
    required UpdateAddressRequest request,
  }) {
    return _repository.updateAddress(addressId: addressId, request: request);
  }
}
