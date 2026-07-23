import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import 'personal_profile_initial_params.dart';
import 'personal_profile_page.dart';

class PersonalProfileNavigator {
  PersonalProfileNavigator(this.navigator);

  late BuildContext context;
  final AppNavigator navigator;

  void goBack() => navigator.pop(context);
}

mixin PersonalProfileRoute {
  void openPersonalProfile(PersonalProfileInitialParams initialParams) {
    navigator.push(
      context,
      '${PersonalProfilePage.path}?${initialParams.toQueryString()}',
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
