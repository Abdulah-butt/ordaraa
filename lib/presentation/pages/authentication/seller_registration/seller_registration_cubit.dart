import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import 'application_received/application_received_initial_params.dart';
import 'seller_registration_initial_params.dart';
import 'seller_registration_navigator.dart';
import 'seller_registration_state.dart';

class SellerRegistrationCubit extends Cubit<SellerRegistrationState> {
  SellerRegistrationCubit({required this.navigator, required this.snackBar})
    : super(SellerRegistrationState.initial());

  final SellerRegistrationNavigator navigator;
  final AppSnackBar snackBar;
  final legalNameController = TextEditingController(
    text: 'Sydney Seafood Co. Pty Ltd',
  );
  final tradingNameController = TextEditingController(
    text: 'Sydney Seafood Co.',
  );
  final abnController = TextEditingController(text: '51 824 753 556');
  final fullNameController = TextEditingController(text: 'Ryan Chen');
  final addressController = TextEditingController(
    text: '18 Marine Way, Sydney NSW 2000',
  );
  String phoneNumber = '+61 412 345 678';

  void onInit(SellerRegistrationInitialParams initialParams) {
    phoneNumber = initialParams.phoneNumber;
  }

  void setMarket(String? value) {
    if (value != null) emit(state.copyWith(market: value));
  }

  void continueToVerification() {
    if (legalNameController.text.trim().isEmpty ||
        abnController.text.trim().isEmpty) {
      snackBar.error('Enter the required business details');
      return;
    }
    emit(state.copyWith(step: SellerRegistrationStep.verification));
  }

  void back() {
    if (state.step == SellerRegistrationStep.verification) {
      emit(state.copyWith(step: SellerRegistrationStep.businessDetails));
    } else {
      navigator.goBack();
    }
  }

  void selectDocument() {
    emit(state.copyWith(documentUploaded: true));
    snackBar.success('Business document selected');
  }

  void toggleAuthorised(bool? value) {
    emit(state.copyWith(authorised: value ?? false));
  }

  void submit() {
    if (fullNameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        !state.authorised) {
      snackBar.error('Complete the verification details');
      return;
    }
    navigator.openApplicationReceived(
      ApplicationReceivedInitialParams(
        businessName: tradingNameController.text.trim(),
        abn: abnController.text.trim(),
        phoneNumber: phoneNumber,
      ),
    );
  }

  void dispose() {}
}
