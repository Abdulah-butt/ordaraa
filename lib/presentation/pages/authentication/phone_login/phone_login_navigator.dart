import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../otp_verification/otp_verification_navigator.dart';
import 'phone_login_initial_params.dart';
import 'phone_login_page.dart';

class PhoneLoginNavigator with OtpVerificationRoute {
  PhoneLoginNavigator(this.navigator);

  @override
  late BuildContext context;

  @override
  late AppNavigator navigator;

  void goBack() => navigator.pop(context);
}

mixin PhoneLoginRoute {
  void openPhoneLogin(PhoneLoginInitialParams initialParams) {
    navigator.push(
      context,
      '${PhoneLoginPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
