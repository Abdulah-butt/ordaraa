import 'package:flutter/material.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../create_account/create_account_navigator.dart';
import 'login_initial_params.dart';
import 'login_page.dart';

class LoginNavigator with CreateAccountRoute {
  LoginNavigator(this.navigator);

  @override
  late BuildContext context;

  @override
  late AppNavigator navigator;
}

mixin LoginRoute {
  openLogin(LoginInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.pushAndClearAllPrevious(
      context,
      "${LoginPage.path}?$queryString",
    );
  }

  AppNavigator get navigator;

  BuildContext get context;
}
