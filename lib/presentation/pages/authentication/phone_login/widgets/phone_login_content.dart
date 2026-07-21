import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_phone_number_field.dart';
import '../../widgets/auth_whatsapp_notice.dart';
import '../phone_login_cubit.dart';
import '../phone_login_state.dart';
import 'phone_login_brand.dart';

class PhoneLoginContent extends StatelessWidget {
  const PhoneLoginContent({
    super.key,
    required this.cubit,
    required this.state,
  });

  final PhoneLoginCubit cubit;
  final PhoneLoginState state;

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
                    const PhoneLoginBrand(),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter your WhatsApp number',
                            style: context.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Use the number you normally use for business orders.',
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    CustomPhoneNumberField(
                      label: 'WhatsApp number',
                      hint: '412 345 678',
                      asFormField: true,
                      bottomPadding: 0,
                      initialCountryCode: 'AU',
                      initialPhoneNumber: '+61 412 345 678',
                      onChange: cubit.onPhoneChanged,
                    ),
                    const SizedBox(height: 18),
                    const AuthWhatsAppNotice(
                      title: 'WhatsApp must be active',
                      description:
                          'We will send your sign-in code and order updates here.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'Send code on WhatsApp',
              onTap: cubit.sendCode,
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
