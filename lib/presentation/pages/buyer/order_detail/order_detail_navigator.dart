import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../seller_detail/seller_detail_initial_params.dart';
import '../seller_detail/seller_detail_navigator.dart';
import 'order_detail_initial_params.dart';
import 'order_detail_page.dart';

class OrderDetailNavigator with SellerDetailRoute {
  OrderDetailNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);

  void openSeller(String sellerId) {
    openSellerDetail(SellerDetailInitialParams(sellerId: sellerId));
  }
}

mixin OrderDetailRoute {
  void openOrderDetail(OrderDetailInitialParams initialParams) {
    navigator.push(
      context,
      '${OrderDetailPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
