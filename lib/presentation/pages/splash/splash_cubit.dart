import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../choose_role/choose_role_initial_params.dart';
import 'splash_initial_params.dart';
import 'splash_navigator.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashNavigator navigator;
  Timer? _navigationTimer;

  SplashCubit({required this.navigator}) : super(SplashState.initial());

  BuildContext get context => navigator.context;

  void onInit(SplashInitialParams initialParams) {
    _navigationTimer?.cancel();
    _navigateToChooseRole();
  }

  void _navigateToChooseRole() {
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (context.mounted) {
        navigator.openChooseRole(const ChooseRoleInitialParams());
      }
    });
  }

  void dispose() {
    _navigationTimer?.cancel();
  }
}
