import 'package:flutter/material.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../buyer/home/buyer_home_navigator.dart';
import '../choose_role/choose_role_navigator.dart';
import '../authentication/buyer_registration/buyer_registration_navigator.dart';
import '../authentication/seller_registration/seller_registration_navigator.dart';
import 'splash_page.dart';
import 'splash_initial_params.dart';

class SplashNavigator
    with
        ChooseRoleRoute,
        BuyerHomeRoute,
        BuyerRegistrationRoute,
        SellerRegistrationRoute {
  SplashNavigator(this.navigator);

  @override
  late BuildContext context;

  @override
  late AppNavigator navigator;
}

mixin SplashRoute {
  void openSplash(SplashInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.push(context, "${SplashPage.path}?$queryString");
  }

  AppNavigator get navigator;

  BuildContext get context;
}
