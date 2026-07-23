import '../../core/enums/address_type.dart';
import '../entities/address.dart';
import '../repositories/database/remote_database_repository.dart';

class GetAddressesUseCase {
  const GetAddressesUseCase(this._repository);

  final RemoteDatabaseRepository _repository;

  Future<List<Address>> execute({AddressType? type}) {
    return _repository.getAddresses(type: type);
  }
}
