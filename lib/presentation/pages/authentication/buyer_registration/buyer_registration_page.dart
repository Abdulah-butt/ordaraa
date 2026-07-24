import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import 'buyer_registration_cubit.dart';
import 'buyer_registration_initial_params.dart';
import 'buyer_registration_state.dart';
import 'widgets/buyer_business_details_form.dart';

class BuyerRegistrationPage extends StatefulWidget {
  const BuyerRegistrationPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer-registration';
  final BuyerRegistrationCubit cubit;
  final BuyerRegistrationInitialParams initialParams;

  @override
  State<BuyerRegistrationPage> createState() => _BuyerRegistrationPageState();
}

class _BuyerRegistrationPageState extends State<BuyerRegistrationPage> {
  BuyerRegistrationCubit get cubit => widget.cubit;

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
    return BlocBuilder<BuyerRegistrationCubit, BuyerRegistrationState>(
      bloc: cubit,
      builder: (context, state) {
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
                    title: 'Business details',
                    onBack: cubit.navigator.goBack,
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
                  const SizedBox(height: 14),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BuyerBusinessDetailsForm(
                        cubit: cubit,
                        state: state,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomButton(
                    text: 'Start ordering',
                    onTap: cubit.startOrdering,
                    isLoading: state.submitting,
                    height: 56,
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: context.colorTheme.primary,
                    foregroundColor: context.colorTheme.onPrimary,
                    textStyle: context.textTheme.labelLarge?.copyWith(
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
