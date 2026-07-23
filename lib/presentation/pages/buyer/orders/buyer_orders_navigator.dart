import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../order_detail/order_detail_initial_params.dart';
import '../order_detail/order_detail_navigator.dart';
import 'buyer_orders_initial_params.dart';
import 'buyer_orders_page.dart';

class BuyerOrdersNavigator with OrderDetailRoute {
  BuyerOrdersNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void openOrder(String orderId) {
    openOrderDetail(OrderDetailInitialParams(orderId: orderId));
  }
}

mixin BuyerOrdersRoute {
  void openBuyerOrders(BuyerOrdersInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.push(context, '${BuyerOrdersPage.path}?$queryString');
  }

  void openBuyerOrdersAndClearStack(BuyerOrdersInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.pushAndClearAllPrevious(
      context,
      '${BuyerOrdersPage.path}?$queryString',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
