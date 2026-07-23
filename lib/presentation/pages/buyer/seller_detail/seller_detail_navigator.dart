import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../product_detail/product_detail_initial_params.dart';
import '../product_detail/product_detail_navigator.dart';
import '../cart/cart_navigator.dart';
import 'seller_detail_initial_params.dart';
import 'seller_detail_page.dart';

class SellerDetailNavigator with ProductDetailRoute, CartRoute {
  SellerDetailNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);

  void openProduct(String productId) {
    openProductDetail(ProductDetailInitialParams(productId: productId));
  }
}

mixin SellerDetailRoute {
  void openSellerDetail(SellerDetailInitialParams initialParams) {
    navigator.push(
      context,
      '${SellerDetailPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
