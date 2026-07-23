import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_phone_number_field.dart';
import '../../../widgets/custom_textfield.dart';
import 'create_account_cubit.dart';
import 'create_account_initial_params.dart';
import 'create_account_state.dart';

class CreateAccountPage extends StatefulWidget {
  final CreateAccountCubit cubit;
  final CreateAccountInitialParams initialParams;

  static const path = '/create_account';

  const CreateAccountPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  @override
  State<CreateAccountPage> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccountPage> {
  CreateAccountCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountCubit, CreateAccountState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorTheme.surface,
          appBar: AppBar(title: const Text("Create Account")),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
              child: Column(
                children: [
                  Icon(Icons.person_3_outlined, size: 50),
                  Text(
                    "Create New Account",
                    style: AppStyle.authHeading(context),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    hint: "Enter your full name",
                    controller: cubit.fullNameController,
                  ),
                  CustomPhoneNumberField(
                    onChange: cubit.onPhoneChanged,
                    hint: "12345678",
                    asFormField: true,
                  ),
                  CustomTextField(
                    hint: "Enter your password",
                    controller: cubit.passwordController,
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
                  CustomTextField(
                    hint: "Confirm your password",
                    controller: cubit.confirmPasswordController,
                    bottomPadding: 0,
                    hide: !state.isConfirmPasswordVisible,
                    suffix: IconButton(
                      onPressed: cubit.toggleConfirmPasswordVisibility,
                      icon: Icon(
                        state.isConfirmPasswordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: context.colorTheme.tertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: "Create Account",
                    onTap: cubit.createAccountAction,
                    width: 274,
                    backgroundColor: context.colorTheme.secondary,
                    isLoading: state.loading,
                  ),
                  const SizedBox(height: 18),
                  RichText(
                    text: TextSpan(
                      style: context.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Already have have an account? ",
                          style: context.textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: "Login",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pop();
                            },
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: context.colorTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
