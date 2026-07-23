import '../../network/request_model/order_listing_request.dart';
import '../entities/order.dart';
import '../entities/paginated_result.dart';
import '../repositories/database/remote_database_repository.dart';

class GetOrdersUseCase {
  const GetOrdersUseCase(this._repository);

  final RemoteDatabaseRepository _repository;

  Future<PaginatedResult<Order>> execute({
    required OrderListingRequest request,
  }) {
    return _repository.getOrders(request: request);
  }
}
