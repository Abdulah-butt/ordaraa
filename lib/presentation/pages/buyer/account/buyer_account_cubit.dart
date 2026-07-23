import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/membership_role.dart';
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
    final displayName = authResult.user?.displayName.trim() ?? '';
    final membership = authResult.memberships.firstOrNull;

    emit(
      state.copyWith(
        displayName: displayName,
        initials: _initials(displayName),
        organizationName: membership?.organization.name ?? '',
        roleLabel: _roleLabel(membership?.membership.role),
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

  void openPersonalProfile() => navigator.openPersonal();

  void openSavedAddresses() => navigator.openAddresses();

  void _deleteAccount() {
    snackBar.info('Account deletion is not available yet');
  }

  String _initials(String name) {
    final words = name.split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  String _roleLabel(MembershipRole? role) {
    return switch (role) {
      MembershipRole.owner => 'Buyer owner',
      MembershipRole.admin => 'Buyer administrator',
      MembershipRole.member => 'Buyer member',
      MembershipRole.viewer => 'Buyer viewer',
      null => 'Buyer account',
    };
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }
}
