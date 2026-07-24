import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import 'seller_registration_cubit.dart';
import 'seller_registration_initial_params.dart';
import 'seller_registration_state.dart';
import 'widgets/registration_step_progress.dart';
import 'widgets/seller_business_details_step.dart';
import 'widgets/seller_verification_step.dart';

class SellerRegistrationPage extends StatefulWidget {
  const SellerRegistrationPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/seller-registration';
  final SellerRegistrationCubit cubit;
  final SellerRegistrationInitialParams initialParams;

  @override
  State<SellerRegistrationPage> createState() => _SellerRegistrationPageState();
}

class _SellerRegistrationPageState extends State<SellerRegistrationPage> {
  SellerRegistrationCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerRegistrationCubit, SellerRegistrationState>(
      bloc: cubit,
      builder: (context, state) {
        final verification = state.step == SellerRegistrationStep.verification;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: context.colorTheme.surface,
          body: SafeArea(
            minimum: const EdgeInsets.only(top: 20, bottom: AppSpacing.lg),
            child: Padding(
              padding: AppSpacing.pageCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppBar(
                    title: verification
                        ? 'Business verification'
                        : 'Business details',
                    subtitle: verification ? 'Step 4 of 4' : 'Step 3 of 4',
                    onBack: cubit.back,
                    trailing: RegistrationStepProgress(
                      activeStep: verification ? 4 : 3,
                    ),
                    actions: [
                      AppBarActionButton(
                        icon: Icons.logout_rounded,
                        tooltip: 'Log out',
                        onPressed: state.isLoggingOut
                            ? null
                            : cubit.confirmLogout,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: SingleChildScrollView(
                      child: verification
                          ? SellerVerificationStep(cubit: cubit, state: state)
                          : SellerBusinessDetailsStep(
                              cubit: cubit,
                              state: state,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: verification ? 'Submit application' : 'Continue',
                    onTap: verification
                        ? cubit.submit
                        : cubit.continueToVerification,
                    height: 56,
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: context.colorTheme.primary,
                    foregroundColor: context.colorTheme.onPrimary,
                    textStyle: context.textTheme.labelLarge?.copyWith(
                      fontSize: 15,
                      color: context.colorTheme.onPrimary,
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
