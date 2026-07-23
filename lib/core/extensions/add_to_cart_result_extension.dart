import '../alert/app_snack_bar.dart';
import '../enums/add_to_cart_result.dart';

extension AddToCartResultFeedback on AddToCartResult {
  void showFeedback(AppSnackBar snackBar) {
    switch (this) {
      case AddToCartResult.added:
        snackBar.success('Added to cart.');
      case AddToCartResult.updated:
        snackBar.success('Cart quantity updated.');
      case AddToCartResult.differentSupplier:
        snackBar.error(
          'Your cart already contains products from another supplier.',
        );
      case AddToCartResult.unavailable:
        snackBar.error('This product is currently unavailable.');
    }
  }
}
