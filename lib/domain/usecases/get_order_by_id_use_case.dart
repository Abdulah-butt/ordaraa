import '../entities/order.dart';
import '../repositories/database/remote_database_repository.dart';

class GetOrderByIdUseCase {
  const GetOrderByIdUseCase(this._repository);

  final RemoteDatabaseRepository _repository;

  Future<Order> execute({required String id}) {
    return _repository.getOrderById(id: id);
  }
}
