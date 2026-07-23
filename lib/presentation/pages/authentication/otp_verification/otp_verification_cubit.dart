import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/auth_flow_destination.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../domain/usecases/request_phone_otp_use_case.dart';
import '../../../../domain/usecases/verify_phone_otp_use_case.dart';
import '../../../../network/request_model/request_phone_otp_request.dart';
import '../../../../network/request_model/verify_phone_otp_request.dart';
import '../../buyer/home/buyer_home_initial_params.dart';
import '../buyer_registration/buyer_registration_initial_params.dart';
import '../seller_registration/seller_registration_initial_params.dart';
import 'otp_verification_initial_params.dart';
import 'otp_verification_navigator.dart';
import 'otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  OtpVerificationCubit({
    required this.navigator,
    required this.snackBar,
    required this.requestPhoneOtpUseCase,
    required this.verifyPhoneOtpUseCase,
  }) : super(OtpVerificationState.initial());

  final OtpVerificationNavigator navigator;
  final AppSnackBar snackBar;
  final RequestPhoneOtpUseCase requestPhoneOtpUseCase;
  final VerifyPhoneOtpUseCase verifyPhoneOtpUseCase;
  final codeController = TextEditingController();
  String phoneNumber = '';
  UserRole role = UserRole.buyer;

  void onInit(OtpVerificationInitialParams initialParams) {
    phoneNumber = initialParams.phoneNumber;
    role = initialParams.role;
    codeController.clear();
    emit(OtpVerificationState.initial());
  }

  void onCodeChanged(String code) {
    emit(state.copyWith(code: code));
  }

  Future<void> verifyNumber() async {
    if (state.code.length != 6) {
      snackBar.error('Please enter the 6-digit code');
      return;
    }
    if (state.loading) return;

    emit(state.copyWith(loading: true));
    try {
      final destination = await verifyPhoneOtpUseCase.execute(
        request: VerifyPhoneOtpRequest(
          phoneNumber: phoneNumber,
          otp: state.code,
        ),
        intendedRole: role,
      );
      snackBar.success('Number verified successfully');
      _navigateAfterVerification(destination);
    } catch (error) {
      snackBar.error(error.toString());
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void _navigateAfterVerification(AuthFlowDestination destination) {
    switch (destination) {
      case AuthFlowDestination.buyerHome:
        navigator.openBuyerHomeAndClearStack(const BuyerHomeInitialParams());
      case AuthFlowDestination.buyerRegistration:
        navigator.openBuyerRegistration(const BuyerRegistrationInitialParams());
      case AuthFlowDestination.sellerRegistration:
        navigator.openSellerRegistration(
          SellerRegistrationInitialParams(phoneNumber: phoneNumber),
        );
      case AuthFlowDestination.sellerWorkspace:
        // Replace this destination with SellerHome when that module is added.
        snackBar.info('Your seller workspace is being prepared');
      case AuthFlowDestination.chooseRole:
        navigator.goBack();
    }
  }

  Future<void> resendCode() async {
    if (state.loading) return;
    emit(state.copyWith(loading: true));
    try {
      await requestPhoneOtpUseCase.execute(
        request: RequestPhoneOtpRequest(phoneNumber: phoneNumber),
      );
      snackBar.info('A new code has been sent to WhatsApp');
    } catch (error) {
      snackBar.error(error.toString());
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void changeNumber() => navigator.goBack();

  void dispose() {
    codeController.clear();
    phoneNumber = '';
  }
}
