import '../entities/product.dart';
import '../repositories/database/remote_database_repository.dart';

class GetProductByIdUseCase {
  const GetProductByIdUseCase(this._remoteDatabaseRepository);

  final RemoteDatabaseRepository _remoteDatabaseRepository;

  Future<Product> execute({required String id}) {
    return _remoteDatabaseRepository.getProductById(id: id);
  }
}
