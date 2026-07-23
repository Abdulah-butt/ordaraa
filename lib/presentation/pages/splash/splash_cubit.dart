import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/auth_flow_destination.dart';
import '../../../domain/usecases/user_login_session_use_case.dart';
import '../authentication/buyer_registration/buyer_registration_initial_params.dart';
import '../authentication/seller_registration/seller_registration_initial_params.dart';
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
    final destination = await userLoginSessionUseCase.execute();
    switch (destination) {
      case AuthFlowDestination.buyerHome:
        navigator.openBuyerHomeAndClearStack(const BuyerHomeInitialParams());
      case AuthFlowDestination.buyerRegistration:
        navigator.openBuyerRegistration(const BuyerRegistrationInitialParams());
      case AuthFlowDestination.sellerRegistration:
        navigator.openSellerRegistration(
          const SellerRegistrationInitialParams(phoneNumber: ''),
        );
      case AuthFlowDestination.sellerWorkspace:
      case AuthFlowDestination.chooseRole:
        navigator.openChooseRole(const ChooseRoleInitialParams());
    }
  }
}
