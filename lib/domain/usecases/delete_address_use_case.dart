import '../repositories/database/remote_database_repository.dart';

class DeleteAddressUseCase {
  const DeleteAddressUseCase(this._repository);

  final RemoteDatabaseRepository _repository;

  Future<void> execute({required String addressId}) {
    return _repository.deleteAddress(addressId: addressId);
  }
}
