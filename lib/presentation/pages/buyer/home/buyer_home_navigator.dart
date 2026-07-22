import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../categories/buyer_categories_navigator.dart';
import '../search/buyer_search_navigator.dart';
import 'buyer_home_initial_params.dart';
import 'buyer_home_page.dart';

class BuyerHomeNavigator with BuyerCategoriesRoute, BuyerSearchRoute {
  BuyerHomeNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;
}

mixin BuyerHomeRoute {
  void openBuyerHome(BuyerHomeInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.push(context, '${BuyerHomePage.path}?$queryString');
  }

  void openBuyerHomeAndClearStack(BuyerHomeInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.pushAndClearAllPrevious(
      context,
      '${BuyerHomePage.path}?$queryString',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
