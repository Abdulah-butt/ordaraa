import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../buyer/home/buyer_home_navigator.dart';
import '../buyer_registration/buyer_registration_navigator.dart';
import '../seller_registration/seller_registration_navigator.dart';
import 'otp_verification_initial_params.dart';
import 'otp_verification_page.dart';

class OtpVerificationNavigator
    with BuyerRegistrationRoute, SellerRegistrationRoute, BuyerHomeRoute {
  OtpVerificationNavigator(this.navigator);

  @override
  final AppNavigator navigator;

  @override
  late BuildContext context;

  void goBack() => navigator.pop(context);
}

mixin OtpVerificationRoute {
  void openOtpVerification(OtpVerificationInitialParams initialParams) {
    navigator.push(
      context,
      '${OtpVerificationPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
