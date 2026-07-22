import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'buyer_orders_initial_params.dart';
import 'buyer_orders_page.dart';

class BuyerOrdersNavigator {
  BuyerOrdersNavigator(this.navigator);

  late BuildContext context;
  final AppNavigator navigator;
}

mixin BuyerOrdersRoute {
  void openBuyerOrders(BuyerOrdersInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.push(context, '${BuyerOrdersPage.path}?$queryString');
  }

  AppNavigator get navigator;
  BuildContext get context;
}
