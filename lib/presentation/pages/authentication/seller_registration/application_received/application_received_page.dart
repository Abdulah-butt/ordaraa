import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../widgets/custom_button.dart';
import 'application_received_cubit.dart';
import 'application_received_initial_params.dart';
import 'application_received_state.dart';
import 'widgets/application_summary_card.dart';

class ApplicationReceivedPage extends StatefulWidget {
  const ApplicationReceivedPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/seller-application-received';
  final ApplicationReceivedCubit cubit;
  final ApplicationReceivedInitialParams initialParams;

  @override
  State<ApplicationReceivedPage> createState() =>
      _ApplicationReceivedPageState();
}

class _ApplicationReceivedPageState extends State<ApplicationReceivedPage> {
  ApplicationReceivedCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationReceivedCubit, ApplicationReceivedState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colorTheme.surface,
          body: SafeArea(
            minimum: const EdgeInsets.only(top: 58, bottom: AppSpacing.lg),
            child: Padding(
              padding: AppSpacing.pageCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: context.ordaraColors.successContainer,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              Assets.check,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Application received',
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineLarge?.copyWith(
                              fontSize: 26,
                              height: 34 / 26,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: context.ordaraColors.warningContainer,
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  Assets.message,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Pending review',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                        color: context.ordaraColors.warning,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'We will verify your ABN, supporting document and authorised contact.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 40),
                          ApplicationSummaryCard(
                            businessName: widget.initialParams.businessName,
                            abn: widget.initialParams.abn,
                            phoneNumber: widget.initialParams.phoneNumber,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Check application status',
                    onTap: cubit.checkStatus,
                    height: 56,
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: context.colorTheme.primary,
                    foregroundColor: context.colorTheme.onPrimary,
                    textStyle: context.textTheme.labelLarge?.copyWith(
                      color: context.colorTheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Back to sign in',
                    onTap: cubit.backToSignIn,
                    isSecondary: true,
                    height: 48,
                    borderRadius: BorderRadius.circular(10),
                    foregroundColor: context.colorTheme.primary,
                    textStyle: context.textTheme.labelLarge?.copyWith(
                      color: context.colorTheme.primary,
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
