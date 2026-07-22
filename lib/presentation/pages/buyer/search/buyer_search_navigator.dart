import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'buyer_search_initial_params.dart';
import 'buyer_search_page.dart';
import 'buyer_search_cubit.dart';
import 'widgets/buyer_search_filter_sheet.dart';

class BuyerSearchNavigator {
  BuyerSearchNavigator(this.navigator);

  late BuildContext context;
  final AppNavigator navigator;

  void showProductFilters({required BuyerSearchCubit cubit}) {
    navigator.showBottomSheet(
      context,
      BuyerSearchFilterSheet(cubit: cubit),
      padding: 20,
    );
  }
}

mixin BuyerSearchRoute {
  void openBuyerSearch(BuyerSearchInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.push(context, '${BuyerSearchPage.path}?$queryString');
  }

  AppNavigator get navigator;
  BuildContext get context;
}
