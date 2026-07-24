import 'package:flutter/material.dart';

import '../../../../../core/navigation/app_navigator.dart';
import '../../../../../domain/entities/address.dart';
import 'add_address_initial_params.dart';
import 'add_address_page.dart';

class AddAddressNavigator {
  AddAddressNavigator(this.navigator);

  late BuildContext context;
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);

  void closeWithAddress(Address address) {
    navigator.popWithResult(context, address);
  }
}

mixin AddAddressRoute {
  Future<Address?> openAddAddress(AddAddressInitialParams initialParams) {
    return navigator.push<Address>(
      context,
      '${AddAddressPage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
