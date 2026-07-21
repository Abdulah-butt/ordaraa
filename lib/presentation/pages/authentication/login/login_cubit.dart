import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/usecases/login_use_case.dart';
import '../../../../network/request_model/login_request.dart';
import '../create_account/create_account_initial_params.dart';
import 'login_initial_params.dart';
import 'login_state.dart';
import 'login_navigator.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginNavigator navigator;
  final LoginUseCase loginUseCase;
  final AppSnackBar snackBar;

  LoginCubit({
    required this.navigator,
    required this.loginUseCase,
    required this.snackBar,
  }) : super(LoginState.initial());

  BuildContext get context => navigator.context;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  bool isValidPhone = false;
  String countryCode = "";
  String phoneNumber = "";

  onInit(LoginInitialParams initialParams) {}

  void onPhoneChanged(String countryCode, String phoneNumber, bool isValid) {
    this.countryCode = countryCode;
    this.phoneNumber = phoneNumber;
    isValidPhone = isValid;
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> loginAction() async {
    try {
      if (!isValidPhone) {
        snackBar.show("Please enter valid phone number");
        return;
      }
      if (passwordController.text.trim().isEmpty) {
        snackBar.show("Please enter password");
        return;
      }
      emit(state.copyWith(loading: true));
      await loginUseCase.execute(
          request: LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ));

      /// TODO: NAVIGATE TO HOME LIKE BELOW
      // navigator.openHome(HomeInitialParams());
    } catch (e) {
      snackBar.show(e.toString());
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void signUpAction() {
    navigator.openCreateAccount(const CreateAccountInitialParams());
  }

  dispose() {
    isValidPhone = false;
    passwordController.clear();
    emailController.clear();
    countryCode = "";
    phoneNumber = "";
  }
}
