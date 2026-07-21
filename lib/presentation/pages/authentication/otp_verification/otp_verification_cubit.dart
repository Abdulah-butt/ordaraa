import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/user_role.dart';
import '../buyer_registration/buyer_registration_initial_params.dart';
import '../seller_registration/seller_registration_initial_params.dart';
import 'otp_verification_initial_params.dart';
import 'otp_verification_navigator.dart';
import 'otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  OtpVerificationCubit({required this.navigator, required this.snackBar})
    : super(OtpVerificationState.initial());

  final OtpVerificationNavigator navigator;
  final AppSnackBar snackBar;
  final codeController = TextEditingController(text: '482731');
  String phoneNumber = '+61 412 345 678';
  UserRole role = UserRole.buyer;

  void onInit(OtpVerificationInitialParams initialParams) {
    phoneNumber = initialParams.phoneNumber;
    role = initialParams.role;
    onCodeChanged(codeController.text);
  }

  void onCodeChanged(String code) {
    emit(state.copyWith(code: code));
  }

  void verifyNumber() {
    if (state.code.length != 6) {
      snackBar.error('Please enter the 6-digit code');
      return;
    }
    snackBar.success('Number verified successfully');
    if (role == UserRole.seller) {
      navigator.openSellerRegistration(
        SellerRegistrationInitialParams(phoneNumber: phoneNumber),
      );
    } else {
      navigator.openBuyerRegistration(
        BuyerRegistrationInitialParams(phoneNumber: phoneNumber),
      );
    }
  }

  void resendCode() {
    snackBar.info('A new code has been sent to WhatsApp');
  }

  void changeNumber() => navigator.goBack();

  void dispose() {
    codeController.text = '482731';
    phoneNumber = '+61 412 345 678';
  }
}
