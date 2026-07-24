import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/address_type.dart';
import '../../../../domain/entities/market.dart';
import '../../../../domain/stores/market_store.dart';
import '../../../../domain/stores/user_store.dart';
import '../../../../domain/usecases/register_buyer_organization_use_case.dart';
import '../../../../domain/usecases/logout_use_case.dart';
import '../../choose_role/choose_role_initial_params.dart';
import '../../../../network/request_model/organization_registration_request.dart';
import '../../../../network/request_model/registration_address_request.dart';
import 'buyer_registration_initial_params.dart';
import 'buyer_registration_navigator.dart';
import 'buyer_registration_state.dart';
import '../../buyer/home/buyer_home_initial_params.dart';

class BuyerRegistrationCubit extends Cubit<BuyerRegistrationState> {
  BuyerRegistrationCubit({
    required this.navigator,
    required this.snackBar,
    required this.marketStore,
    required this.userStore,
    required this.registerBuyerOrganizationUseCase,
    required this.logoutUseCase,
  }) : super(BuyerRegistrationState.initial());

  final BuyerRegistrationNavigator navigator;
  final AppSnackBar snackBar;
  final MarketStore marketStore;
  final UserStore userStore;
  final RegisterBuyerOrganizationUseCase registerBuyerOrganizationUseCase;
  final LogoutUseCase logoutUseCase;
  final businessNameController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  List<Market> get markets => marketStore.state;
  String get phoneNumber => userStore.state.user?.phone.trim() ?? '';

  Future<void> onInit(BuyerRegistrationInitialParams initialParams) async {
    emit(BuyerRegistrationState.initial().copyWith(loadingMarkets: true));
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

  void confirmLogout() {
    if (state.isLoggingOut) return;
    navigator.showLogoutConfirmation(onConfirm: logout);
  }

  Future<void> logout() async {
    if (state.isLoggingOut) return;
    emit(state.copyWith(isLoggingOut: true));
    try {
      await logoutUseCase.execute();
      if (navigator.context.mounted) {
        navigator.openChooseRole(const ChooseRoleInitialParams());
      }
    } catch (error) {
      snackBar.error(error.toString());
      emit(state.copyWith(isLoggingOut: false));
    }
  }

  Future<void> startOrdering() async {
    if (state.submitting) return;
    final selectedMarket = state.selectedMarket;
    if (businessNameController.text.trim().isEmpty ||
        addressLine1Controller.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        selectedMarket == null) {
      snackBar.error('Complete your business details');
      return;
    }

    emit(state.copyWith(submitting: true));
    try {
      await registerBuyerOrganizationUseCase.execute(
        request: OrganizationRegistrationRequest(
          name: businessNameController.text.trim(),
          marketId: selectedMarket.id,
          contactPhone: phoneNumber.isEmpty ? null : phoneNumber,
          address: RegistrationAddressRequest(
            type: AddressType.delivery,
            line1: addressLine1Controller.text.trim(),
            city: cityController.text.trim(),
            countryCode: selectedMarket.countryCode,
            state: _optionalValue(stateController),
            postalCode: _optionalValue(postalCodeController),
            contactPhone: phoneNumber.isEmpty ? null : phoneNumber,
          ),
        ),
      );
      snackBar.success('Business setup complete');
      navigator.openBuyerHomeAndClearStack(const BuyerHomeInitialParams());
    } catch (error) {
      snackBar.error(error.toString());
    } finally {
      emit(state.copyWith(submitting: false));
    }
  }

  String? _optionalValue(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void dispose() {
    businessNameController.clear();
    addressLine1Controller.clear();
    cityController.clear();
    stateController.clear();
    postalCodeController.clear();
  }
}
