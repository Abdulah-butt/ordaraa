import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'buyer_registration_initial_params.dart';
import 'buyer_registration_page.dart';

class BuyerRegistrationNavigator {
  BuyerRegistrationNavigator(this.navigator);

  late BuildContext context;
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);
}

mixin BuyerRegistrationRoute {
  void openBuyerRegistration(BuyerRegistrationInitialParams initialParams) {
    navigator.pushAndClearAllPrevious(
      context,
      '${BuyerRegistrationPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
