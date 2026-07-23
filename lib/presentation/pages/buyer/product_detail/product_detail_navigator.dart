import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../seller_detail/seller_detail_initial_params.dart';
import '../seller_detail/seller_detail_navigator.dart';
import '../cart/cart_navigator.dart';
import 'product_detail_initial_params.dart';
import 'product_detail_page.dart';

class ProductDetailNavigator with SellerDetailRoute, CartRoute {
  ProductDetailNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);

  void openSeller(String sellerId) {
    openSellerDetail(SellerDetailInitialParams(sellerId: sellerId));
  }
}

mixin ProductDetailRoute {
  void openProductDetail(ProductDetailInitialParams initialParams) {
    navigator.push(
      context,
      '${ProductDetailPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
