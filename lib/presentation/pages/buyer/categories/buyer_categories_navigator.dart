import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../search/buyer_search_navigator.dart';
import 'buyer_categories_initial_params.dart';
import 'buyer_categories_page.dart';

class BuyerCategoriesNavigator with BuyerSearchRoute {
  BuyerCategoriesNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);
}

mixin BuyerCategoriesRoute {
  void openBuyerCategories(BuyerCategoriesInitialParams initialParams) {
    navigator.push(
      context,
      '${BuyerCategoriesPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
