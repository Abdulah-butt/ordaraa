import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/stores/user_store.dart';
import '../../../../domain/usecases/update_user_profile_use_case.dart';
import '../../../../network/request_model/update_user_profile_request.dart';
import 'personal_profile_initial_params.dart';
import 'personal_profile_navigator.dart';
import 'personal_profile_state.dart';

class PersonalProfileCubit extends Cubit<PersonalProfileState> {
  PersonalProfileCubit({
    required this.navigator,
    required this.userStore,
    required this.updateUserProfileUseCase,
    required this.snackBar,
  }) : super(PersonalProfileState.initial());

  final PersonalProfileNavigator navigator;
  final UserStore userStore;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final AppSnackBar snackBar;
  final displayNameController = TextEditingController();

  void onInit(PersonalProfileInitialParams initialParams) {
    final user = userStore.state.user;
    if (user == null) return;
    displayNameController.text = user.displayName;
    emit(state.copyWith(user: () => user, locale: user.locale));
  }

  void setLocale(String? locale) {
    if (locale != null) emit(state.copyWith(locale: locale));
  }

  Future<void> save() async {
    if (state.saving || state.user == null) return;
    final displayName = displayNameController.text.trim();
    if (displayName.isEmpty) {
      snackBar.error('Enter your name');
      return;
    }
    if (displayName.length > 120) {
      snackBar.error('Your name cannot exceed 120 characters');
      return;
    }
    if (!RegExp(r'^[a-z]{2}(-[A-Z]{2})?$').hasMatch(state.locale)) {
      snackBar.error('Select a valid language and region');
      return;
    }

    emit(state.copyWith(saving: true));
    try {
      final user = await updateUserProfileUseCase.execute(
        request: UpdateUserProfileRequest(
          displayName: displayName,
          locale: state.locale,
        ),
      );
      emit(
        state.copyWith(user: () => user, locale: user.locale, saving: false),
      );
      snackBar.success('Personal profile updated');
    } catch (error) {
      emit(state.copyWith(saving: false));
      snackBar.error(error.toString());
    }
  }

  @override
  Future<void> close() {
    displayNameController.dispose();
    return super.close();
  }
}
