import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/user_login_session_use_case.dart';
import '../buyer/home/buyer_home_initial_params.dart';
import '../choose_role/choose_role_initial_params.dart';
import 'splash_initial_params.dart';
import 'splash_navigator.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required this.navigator, required this.userLoginSessionUseCase})
    : super(SplashState.initial());

  final SplashNavigator navigator;
  final UserLoginSessionUseCase userLoginSessionUseCase;

  void onInit(SplashInitialParams initialParams) {
    emit(state.copyWith(loading: true));
    _resolveInitialRoute();
  }

  Future<void> _resolveInitialRoute() async {
    var result = await userLoginSessionUseCase.execute();
    if (result) {
      navigator.openBuyerHomeAndClearStack(const BuyerHomeInitialParams());
      return;
    }
    navigator.openChooseRole(ChooseRoleInitialParams());
  }
}
