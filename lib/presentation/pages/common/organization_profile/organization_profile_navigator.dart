import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'organization_profile_initial_params.dart';
import 'organization_profile_page.dart';

class OrganizationProfileNavigator {
  OrganizationProfileNavigator(this.navigator);

  late BuildContext context;
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);
}

mixin OrganizationProfileRoute {
  void openOrganizationProfile(OrganizationProfileInitialParams initialParams) {
    navigator.push(
      context,
      '${OrganizationProfilePage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
