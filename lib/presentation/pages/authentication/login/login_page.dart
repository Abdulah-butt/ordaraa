import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_phone_number_field.dart';
import '../../../widgets/custom_textfield.dart';
import 'login_cubit.dart';
import 'login_initial_params.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  final LoginCubit cubit;
  final LoginInitialParams initialParams;

  static const path = '/login';

  const LoginPage(
      {super.key, required this.cubit, required this.initialParams});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  LoginCubit get cubit => widget.cubit;
  late final TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
    _signUpRecognizer = TapGestureRecognizer()..onTap = cubit.signUpAction;
  }

  @override
  void dispose() {
    _signUpRecognizer.dispose();
    cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorTheme.surface,
          appBar: AppBar(title: Text("Login")),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
              child: Column(
                children: [
                  Icon(
                    Icons.login,
                    size: 50,
                  ),
                  Text("Login", style: AppStyle.authHeading(context)),
                  SizedBox(height: 30),
                  CustomPhoneNumberField(
                    onChange: cubit.onPhoneChanged,
                    hint: "12345678",
                    asFormField: true,
                  ),
                  CustomTextField(
                    hint: "Enter your password",
                    controller: cubit.passwordController,
                    bottomPadding: 0,
                    hide: !state.isPasswordVisible,
                    suffix: IconButton(
                      onPressed: cubit.togglePasswordVisibility,
                      icon: Icon(
                        state.isPasswordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: context.colorTheme.tertiary,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorTheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    text: "Login",
                    onTap: cubit.loginAction,
                    isLoading: state.loading,
                    width: 274,
                    backgroundColor: context.colorTheme.secondary,
                  ),
                  const SizedBox(height: 18),
                  RichText(
                    text: TextSpan(
                      style: context.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: context.textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: "Sign up",
                          recognizer: _signUpRecognizer,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: context.colorTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
