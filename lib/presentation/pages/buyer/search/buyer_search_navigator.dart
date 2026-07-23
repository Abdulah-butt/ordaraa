import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'buyer_search_initial_params.dart';
import 'buyer_search_page.dart';
import 'buyer_search_cubit.dart';
import 'widgets/buyer_search_filter_sheet.dart';
import '../product_detail/product_detail_initial_params.dart';
import '../product_detail/product_detail_navigator.dart';
import '../seller_detail/seller_detail_initial_params.dart';
import '../seller_detail/seller_detail_navigator.dart';

class BuyerSearchNavigator with ProductDetailRoute, SellerDetailRoute {
  BuyerSearchNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void openProduct(String productId) {
    openProductDetail(ProductDetailInitialParams(productId: productId));
  }

  void openSeller(String sellerId) {
    openSellerDetail(SellerDetailInitialParams(sellerId: sellerId));
  }

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
