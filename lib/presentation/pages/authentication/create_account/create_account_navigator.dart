import 'package:flutter/material.dart';
import '../../../../core/navigation/app_navigator.dart';
import 'create_account_page.dart';
import 'create_account_initial_params.dart';

class CreateAccountNavigator {
  CreateAccountNavigator(this.navigator);

  late BuildContext context;

  late AppNavigator navigator;
}

mixin CreateAccountRoute {
  openCreateAccount(CreateAccountInitialParams initialParams) {
    final queryString = initialParams.toQueryString();

    navigator.push(
      context,
      "${CreateAccountPage.path}?$queryString",
    );
  }

  AppNavigator get navigator;

  BuildContext get context;
}
