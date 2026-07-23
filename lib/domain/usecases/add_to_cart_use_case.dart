import '../../core/enums/add_to_cart_result.dart';
import '../../core/enums/listing_status.dart';
import '../../core/enums/stock_status.dart';
import '../entities/product.dart';
import '../stores/cart_store.dart';

class AddToCartUseCase {
  const AddToCartUseCase(this._cartStore);

  final CartStore _cartStore;

  AddToCartResult execute({required Product product, int? quantity}) {
    if (product.status != ListingStatus.active ||
        product.stockStatus == StockStatus.outOfStock ||
        product.stockStatus == StockStatus.unavailable) {
      return AddToCartResult.unavailable;
    }

    final currentSellerId = _cartStore.state.seller?.id;
    if (currentSellerId != null && currentSellerId != product.seller.id) {
      return AddToCartResult.differentSupplier;
    }

    final alreadyExists = _cartStore.state.items.any(
      (item) => item.product.id == product.id,
    );
    final requestedQuantity =
        quantity ?? _positiveQuantity(product.minimumOrderQuantity);
    _cartStore.put(product, requestedQuantity < 1 ? 1 : requestedQuantity);
    return alreadyExists ? AddToCartResult.updated : AddToCartResult.added;
  }

  int _positiveQuantity(String value) {
    final parsed = (num.tryParse(value) ?? 1).ceil();
    return parsed < 1 ? 1 : parsed;
  }
}
