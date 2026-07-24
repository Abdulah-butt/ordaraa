import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../../domain/entities/address.dart';
import '../../../sheets/confirmation_sheet.dart';
import 'add_address/add_address_navigator.dart';
import 'saved_addresses_initial_params.dart';
import 'saved_addresses_page.dart';

class SavedAddressesNavigator with AddAddressRoute {
  SavedAddressesNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);

  void confirmDeleteAddress({
    required Address address,
    required VoidCallback onConfirm,
  }) {
    navigator.showBottomSheet(
      context,
      ConfirmationSheet(
        initialParams: ConfirmationSheetInitialParams(
          title: 'Delete this address?',
          subTitle:
              '${address.label ?? address.type.displayText} will be removed from your organization’s saved addresses.',
          primaryBtnText: 'Delete address',
          secondaryBtnText: 'Keep address',
          type: ConfirmationSheetType.destructive,
          icon: Icons.location_off_outlined,
          primaryButtonIcon: Icons.delete_outline_rounded,
          btnAction: onConfirm,
        ),
      ),
    );
  }
}

mixin SavedAddressesRoute {
  void openSavedAddresses(SavedAddressesInitialParams initialParams) {
    navigator.push(
      context,
      '${SavedAddressesPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
