import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/stores/user_store.dart';
import '../../../../domain/entities/auth_result.dart';
import '../../../../domain/usecases/logout_use_case.dart';
import '../../choose_role/choose_role_initial_params.dart';
import 'buyer_account_initial_params.dart';
import 'buyer_account_navigator.dart';
import 'buyer_account_state.dart';

class BuyerAccountCubit extends Cubit<BuyerAccountState> {
  BuyerAccountCubit({
    required this.navigator,
    required this.userStore,
    required this.logoutUseCase,
    required this.snackBar,
  }) : super(BuyerAccountState.initial());

  final BuyerAccountNavigator navigator;
  final UserStore userStore;
  final LogoutUseCase logoutUseCase;
  final AppSnackBar snackBar;
  StreamSubscription<AuthResult>? _userSubscription;

  void onInit(BuyerAccountInitialParams initialParams) {
    _syncFromUserStore(userStore.state);
    _userSubscription ??= userStore.stream.listen(_syncFromUserStore);
  }

  void _syncFromUserStore(AuthResult authResult) {
    final membership = authResult.memberships.firstOrNull;
    final organization = membership?.organization;
    final organizationName = organization?.name.trim() ?? '';

    emit(
      state.copyWith(
        initials: _initials(organizationName),
        organizationName: organizationName,
        organizationSubtitle: organization == null
            ? ''
            : '${organization.type.displayText} business • ${organization.market.name}',
        organizationVerified: organization?.verified ?? false,
      ),
    );
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
    } finally {
      emit(state.copyWith(isLoggingOut: false));
    }
  }

  void confirmLogout() {
    navigator.showLogoutConfirmation(onConfirm: logout);
  }

  void confirmDeleteAccount() {
    navigator.showDeleteAccountConfirmation(onConfirm: _deleteAccount);
  }

  void openOrganizationProfile() => navigator.openOrganization();

  void openSavedAddresses() => navigator.openAddresses();

  void _deleteAccount() {
    snackBar.info('Account deletion is not available yet');
  }

  String _initials(String name) {
    final words = name.split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }
}
