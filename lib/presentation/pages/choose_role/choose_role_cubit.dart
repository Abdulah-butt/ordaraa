import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/user_role.dart';
import '../authentication/phone_login/phone_login_initial_params.dart';
import 'choose_role_initial_params.dart';
import 'choose_role_navigator.dart';
import 'choose_role_state.dart';

class ChooseRoleCubit extends Cubit<ChooseRoleState> {
  ChooseRoleCubit({required this.navigator}) : super(ChooseRoleState.initial());

  final ChooseRoleNavigator navigator;

  void onInit(ChooseRoleInitialParams initialParams) {}

  void onRoleSelected(UserRole role) {
    emit(state.copyWith(selectedRole: role));
    navigator.openPhoneLogin(PhoneLoginInitialParams(role: role));
  }
}
