import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../../domain/entities/address.dart';
import '../order_confirmed/order_confirmed_initial_params.dart';
import '../order_confirmed/order_confirmed_navigator.dart';
import 'checkout_initial_params.dart';
import 'checkout_page.dart';
import 'widgets/checkout_address_sheet.dart';

class CheckoutNavigator with OrderConfirmedRoute {
  CheckoutNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);

  Future<void> chooseAddress({
    required List<Address> addresses,
    required Address? selectedAddress,
    required ValueChanged<Address> onSelected,
  }) async {
    final address = await navigator.showBottomSheet<Address>(
      context,
      CheckoutAddressSheet(
        addresses: addresses,
        selectedAddress: selectedAddress,
      ),
    );
    if (address != null) {
      onSelected(address);
    }
  }

  void showConfirmation(String orderId) {
    replaceWithOrderConfirmed(OrderConfirmedInitialParams(orderId: orderId));
  }
}

mixin CheckoutRoute {
  void openCheckout([
    CheckoutInitialParams initialParams = const CheckoutInitialParams(),
  ]) {
    navigator.push(context, CheckoutPage.path);
  }

  AppNavigator get navigator;
  BuildContext get context;
}
