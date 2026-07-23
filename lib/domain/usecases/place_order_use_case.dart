import '../../network/request_model/checkout_request.dart';
import '../entities/order.dart';
import '../repositories/database/remote_database_repository.dart';

class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repository);

  final RemoteDatabaseRepository _repository;

  Future<Order> execute({
    required CheckoutRequest request,
    required String idempotencyKey,
  }) {
    return _repository.placeOrder(
      request: request,
      idempotencyKey: idempotencyKey,
    );
  }
}
