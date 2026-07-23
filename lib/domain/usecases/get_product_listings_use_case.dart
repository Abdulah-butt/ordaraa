import '../../network/request_model/product_listing_request.dart';
import '../entities/paginated_result.dart';
import '../entities/product.dart';
import '../repositories/database/remote_database_repository.dart';

class GetProductListingsUseCase {
  const GetProductListingsUseCase(this._remoteDatabaseRepository);

  final RemoteDatabaseRepository _remoteDatabaseRepository;

  Future<PaginatedResult<Product>> execute({
    required ProductListingRequest request,
  }) {
    return _remoteDatabaseRepository.getProductListings(request: request);
  }
}
