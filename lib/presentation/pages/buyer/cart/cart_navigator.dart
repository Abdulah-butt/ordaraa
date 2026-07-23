import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../sheets/confirmation_sheet.dart';
import '../home/buyer_home_initial_params.dart';
import '../home/buyer_home_navigator.dart';
import '../checkout/checkout_navigator.dart';
import '../product_detail/product_detail_initial_params.dart';
import '../product_detail/product_detail_navigator.dart';
import '../seller_detail/seller_detail_initial_params.dart';
import '../seller_detail/seller_detail_navigator.dart';
import 'cart_initial_params.dart';
import 'cart_page.dart';

class CartNavigator
    with BuyerHomeRoute, ProductDetailRoute, SellerDetailRoute, CheckoutRoute {
  CartNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);

  void browseProducts() {
    openBuyerHomeAndClearStack(const BuyerHomeInitialParams());
  }

  void openProduct(String productId) {
    openProductDetail(ProductDetailInitialParams(productId: productId));
  }

  void openSeller(String sellerId) {
    openSellerDetail(SellerDetailInitialParams(sellerId: sellerId));
  }

  void confirmClear(VoidCallback onConfirmed) {
    navigator.showBottomSheet(
      context,
      ConfirmationSheet(
        initialParams: ConfirmationSheetInitialParams(
          title: 'Clear your cart?',
          subTitle: 'This removes every product currently in your cart.',
          primaryBtnText: 'Clear cart',
          secondaryBtnText: 'Keep shopping',
          type: ConfirmationSheetType.destructive,
          icon: Icons.remove_shopping_cart_outlined,
          btnAction: onConfirmed,
        ),
      ),
    );
  }
}

mixin CartRoute {
  void openCart([CartInitialParams initialParams = const CartInitialParams()]) {
    navigator.push(context, CartPage.path);
  }

  AppNavigator get navigator;
  BuildContext get context;
}
