import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../sheets/confirmation_sheet.dart';
import '../../choose_role/choose_role_navigator.dart';
import 'buyer_account_initial_params.dart';
import 'buyer_account_page.dart';

class BuyerAccountNavigator with ChooseRoleRoute {
  BuyerAccountNavigator(this.navigator);

  @override
  late BuildContext context;
  @override
  final AppNavigator navigator;

  void showLogoutConfirmation({required VoidCallback onConfirm}) {
    navigator.showBottomSheet(
      context,
      ConfirmationSheet(
        initialParams: ConfirmationSheetInitialParams(
          title: 'Log out?',
          subTitle: 'Are you sure you want to log out of your account?',
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

  void showDeleteAccountConfirmation({required VoidCallback onConfirm}) {
    navigator.showBottomSheet(
      context,
      ConfirmationSheet(
        initialParams: ConfirmationSheetInitialParams(
          title: 'Delete account?',
          subTitle:
              'This will permanently delete your account and cannot be undone.',
          primaryBtnText: 'Delete account',
          secondaryBtnText: 'Cancel',
          type: ConfirmationSheetType.destructive,
          icon: Icons.person_remove_rounded,
          primaryButtonIcon: Icons.delete_outline_rounded,
          btnAction: onConfirm,
        ),
      ),
    );
  }
}

mixin BuyerAccountRoute {
  void openBuyerAccount(BuyerAccountInitialParams initialParams) {
    final queryString = initialParams.toQueryString();
    navigator.push(context, '${BuyerAccountPage.path}?$queryString');
  }

  AppNavigator get navigator;
  BuildContext get context;
}
