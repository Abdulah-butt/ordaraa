import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../home/buyer_home_initial_params.dart';
import '../home/buyer_home_navigator.dart';
import '../orders/buyer_orders_initial_params.dart';
import '../orders/buyer_orders_navigator.dart';
import 'order_confirmed_initial_params.dart';
import 'order_confirmed_page.dart';

class OrderConfirmedNavigator with BuyerHomeRoute, BuyerOrdersRoute {
  OrderConfirmedNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void viewOrders() {
    openBuyerOrdersAndClearStack(const BuyerOrdersInitialParams());
  }

  void continueShopping() {
    openBuyerHomeAndClearStack(const BuyerHomeInitialParams());
  }
}

mixin OrderConfirmedRoute {
  void replaceWithOrderConfirmed(OrderConfirmedInitialParams initialParams) {
    navigator.replace(
      context,
      '${OrderConfirmedPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
