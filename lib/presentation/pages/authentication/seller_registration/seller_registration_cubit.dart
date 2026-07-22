import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/entities/market.dart';
import '../../../../domain/stores/market_store.dart';
import 'application_received/application_received_initial_params.dart';
import 'seller_registration_initial_params.dart';
import 'seller_registration_navigator.dart';
import 'seller_registration_state.dart';

class SellerRegistrationCubit extends Cubit<SellerRegistrationState> {
  SellerRegistrationCubit({
    required this.navigator,
    required this.snackBar,
    required this.marketStore,
  }) : super(SellerRegistrationState.initial());

  final SellerRegistrationNavigator navigator;
  final AppSnackBar snackBar;
  final MarketStore marketStore;
  final legalNameController = TextEditingController();
  final tradingNameController = TextEditingController();
  final abnController = TextEditingController();
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  String phoneNumber = '';

  List<Market> get markets => marketStore.state;

  Future<void> onInit(SellerRegistrationInitialParams initialParams) async {
    phoneNumber = initialParams.phoneNumber;
    emit(SellerRegistrationState.initial().copyWith(loadingMarkets: true));
    try {
      final availableMarkets = await marketStore.loadMarkets();
      emit(
        state.copyWith(
          selectedMarket: () =>
              availableMarkets.isEmpty ? null : availableMarkets.first,
          loadingMarkets: false,
        ),
      );
    } catch (error) {
      emit(state.copyWith(loadingMarkets: false));
      snackBar.error(error.toString());
    }
  }

  void setMarket(Market? value) {
    if (value != null) {
      emit(state.copyWith(selectedMarket: () => value));
    }
  }

  void continueToVerification() {
    if (legalNameController.text.trim().isEmpty ||
        abnController.text.trim().isEmpty ||
        state.selectedMarket == null) {
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

  void dispose() {
    legalNameController.clear();
    tradingNameController.clear();
    abnController.clear();
    fullNameController.clear();
    addressController.clear();
    phoneNumber = '';
  }
}
