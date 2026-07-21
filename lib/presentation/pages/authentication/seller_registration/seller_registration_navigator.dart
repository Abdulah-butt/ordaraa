import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'application_received/application_received_navigator.dart';
import 'seller_registration_initial_params.dart';
import 'seller_registration_page.dart';

class SellerRegistrationNavigator with ApplicationReceivedRoute {
  SellerRegistrationNavigator(this.navigator);

  @override
  late BuildContext context;

  @override
  late AppNavigator navigator;

  void goBack() => navigator.pop(context);
}

mixin SellerRegistrationRoute {
  void openSellerRegistration(SellerRegistrationInitialParams initialParams) {
    navigator.pushAndClearAllPrevious(
      context,
      '${SellerRegistrationPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
