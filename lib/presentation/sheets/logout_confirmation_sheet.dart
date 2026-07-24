import 'package:flutter/material.dart';

import '../../core/navigation/app_navigator.dart';
import 'confirmation_sheet.dart';

mixin LogoutConfirmationSheetRoute {
  void showLogoutConfirmation({required VoidCallback onConfirm}) {
    navigator.showBottomSheet(
      context,
      ConfirmationSheet(
        initialParams: ConfirmationSheetInitialParams(
          title: 'Log out?',
          subTitle:
              'You’ll need to sign in again to continue using your account.',
          primaryBtnText: 'Log out',
          secondaryBtnText: 'Cancel',
          type: ConfirmationSheetType.warning,
          icon: Icons.logout_rounded,
          primaryButtonIcon: Icons.logout_rounded,
          btnAction: onConfirm,
        ),
      ),
    );
  }

  AppNavigator get navigator;
  BuildContext get context;
}
