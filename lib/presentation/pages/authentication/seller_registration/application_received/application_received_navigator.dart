import 'package:flutter/material.dart';

import '../../../../../core/navigation/app_navigator.dart';
import '../../phone_login/phone_login_navigator.dart';
import 'application_received_initial_params.dart';
import 'application_received_page.dart';

class ApplicationReceivedNavigator with PhoneLoginRoute {
  ApplicationReceivedNavigator(this.navigator);

  @override
  late BuildContext context;

  @override
  late AppNavigator navigator;
}

mixin ApplicationReceivedRoute {
  void openApplicationReceived(ApplicationReceivedInitialParams initialParams) {
    navigator.pushAndClearAllPrevious(
      context,
      '${ApplicationReceivedPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
