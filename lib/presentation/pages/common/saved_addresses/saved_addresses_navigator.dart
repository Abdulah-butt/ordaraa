import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'saved_addresses_initial_params.dart';
import 'saved_addresses_page.dart';

class SavedAddressesNavigator {
  SavedAddressesNavigator(this.navigator);

  late BuildContext context;
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);
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
