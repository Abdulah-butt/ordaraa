import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/usecases/signup_use_case.dart';
import '../../../../network/request_model/create_account_request.dart';
import 'create_account_initial_params.dart';
import 'create_account_state.dart';
import 'create_account_navigator.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountNavigator navigator;
  final SignupUseCase signupUseCase;
  final AppSnackBar snackBar;

  CreateAccountCubit({
    required this.navigator,
    required this.signupUseCase,
    required this.snackBar,
  }) : super(CreateAccountState.initial());

  BuildContext get context => navigator.context;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isValidPhone = false;
  String countryCode = "";
  String phoneNumber = "";

  onInit(CreateAccountInitialParams initialParams) {
    fullNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    emailController.clear();
  }

  void onPhoneChanged(String countryCode, String phoneNumber, bool isValid) {
    this.countryCode = countryCode;
    this.phoneNumber = phoneNumber;
    isValidPhone = isValid;
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  Future<void> createAccountAction() async {
    try {
      final fullName = fullNameController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();
      final email = emailController.text.trim();

      if (fullName.isEmpty || password.isEmpty || email.isEmpty) {
        snackBar.show("Please enter compulsory fields");
        return;
      }
      if (!isValidPhone) {
        snackBar.show("Please enter valid phone number");
        return;
      }
      if (password != confirmPassword) {
        snackBar.show("Passwords do not match");
        return;
      }

      emit(state.copyWith(loading: true));
      await signupUseCase.execute(
          request: CreateAccountRequest(
        name: fullName,
        email: email,
        password: password,
      ));
      /// TODO: NAVIGATE TO HOME PAGE
      //navigator.openHome(HomeInitialParams());
    } catch (e) {
      snackBar.show(e.toString());
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  dispose() {
    isValidPhone = false;
    countryCode = "";
    phoneNumber = "";
    fullNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
