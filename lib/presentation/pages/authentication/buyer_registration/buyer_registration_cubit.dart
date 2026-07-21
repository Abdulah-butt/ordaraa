import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import 'buyer_registration_initial_params.dart';
import 'buyer_registration_navigator.dart';
import 'buyer_registration_state.dart';

class BuyerRegistrationCubit extends Cubit<BuyerRegistrationState> {
  BuyerRegistrationCubit({required this.navigator, required this.snackBar})
    : super(BuyerRegistrationState.initial());

  final BuyerRegistrationNavigator navigator;
  final AppSnackBar snackBar;
  final businessNameController = TextEditingController(
    text: 'Harbour Fresh Market',
  );
  final addressController = TextEditingController(
    text: '24 Harbour Street, Sydney NSW 2000',
  );
  String phoneNumber = '+61 412 345 678';

  void onInit(BuyerRegistrationInitialParams initialParams) {
    phoneNumber = initialParams.phoneNumber;
  }

  void setMarket(String? value) {
    if (value != null) emit(state.copyWith(market: value));
  }

  void startOrdering() {
    if (businessNameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      snackBar.error('Complete your business details');
      return;
    }
    snackBar.success('Business setup complete');
  }

  void dispose() {}
}
