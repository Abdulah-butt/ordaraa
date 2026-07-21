import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_button.dart';
import '../../widgets/auth_whatsapp_notice.dart';
import '../otp_verification_cubit.dart';
import '../otp_verification_state.dart';
import 'otp_code_field.dart';

class OtpVerificationContent extends StatelessWidget {
  const OtpVerificationContent({
    super.key,
    required this.cubit,
    required this.state,
  });

  final OtpVerificationCubit cubit;
  final OtpVerificationState state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 20, bottom: AppSpacing.lg),
      child: Padding(
        padding: AppSpacing.pageCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomAppBar(
                      title: 'Verify your number',
                      onBack: cubit.changeNumber,
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.ordaraColors.supplierContainer
                              .withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          Assets.check,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Enter the code from WhatsApp',
                      style: context.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'We sent a 6-digit code to ${cubit.phoneNumber}.',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    OtpCodeField(
                      controller: cubit.codeController,
                      onChanged: cubit.onCodeChanged,
                      onCompleted: (_) => cubit.verifyNumber(),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ActionText(
                            label: 'Change number',
                            onTap: cubit.changeNumber,
                          ),
                          _ActionText(
                            label: 'Resend code',
                            onTap: cubit.resendCode,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const AuthWhatsAppNotice(
                      height: 72,
                      title: 'Check your WhatsApp messages',
                      description:
                          'The code usually arrives within a few seconds.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'Verify number',
              onTap: cubit.verifyNumber,
              isLoading: state.loading,
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
    );
  }
}

class _ActionText extends StatelessWidget {
  const _ActionText({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorTheme.primary,
          ),
        ),
      ),
    );
  }
}
