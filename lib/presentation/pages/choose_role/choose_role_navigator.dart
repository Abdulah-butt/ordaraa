import 'package:flutter/material.dart';

import '../../../core/navigation/app_navigator.dart';
import '../authentication/phone_login/phone_login_navigator.dart';
import 'choose_role_initial_params.dart';
import 'choose_role_page.dart';

class ChooseRoleNavigator with PhoneLoginRoute {
  ChooseRoleNavigator(this.navigator);

  @override
  late BuildContext context;

  @override
  late AppNavigator navigator;
}

mixin ChooseRoleRoute {
  void openChooseRole(ChooseRoleInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.pushAndClearAllPrevious(
      context,
      '${ChooseRolePage.path}?$queryString',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
