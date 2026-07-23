import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../widgets/custom_drop_down.dart';
import '../../../../widgets/custom_textfield.dart';
import '../personal_profile_cubit.dart';
import '../personal_profile_state.dart';
import 'personal_profile_header.dart';
import 'verified_identity_card.dart';

const _localeLabels = <String, String>{
  'en-AU': 'English (Australia)',
  'en-GB': 'English (United Kingdom)',
  'en-US': 'English (United States)',
};

class PersonalProfileContent extends StatelessWidget {
  const PersonalProfileContent({
    super.key,
    required this.cubit,
    required this.state,
  });

  final PersonalProfileCubit cubit;
  final PersonalProfileState state;

  @override
  Widget build(BuildContext context) {
    final user = state.user!;
    final locales = {
      ..._localeLabels.keys,
      state.locale,
    }.toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonalProfileHeader(displayName: user.displayName, phone: user.phone),
        const SizedBox(height: AppSpacing.lg),
        _ProfileSection(
          icon: Icons.person_outline_rounded,
          title: 'Personal information',
          subtitle: 'How your name appears across Ordaraa.',
          child: Column(
            children: [
              CustomTextField(
                controller: cubit.displayNameController,
                label: 'Display name',
                hint: 'Enter your full name',
                inputFormatters: [LengthLimitingTextInputFormatter(120)],
                action: TextInputAction.done,
              ),
              CustomDropdown<String>(
                label: 'Language and region',
                items: locales,
                value: state.locale,
                onChanged: cubit.setLocale,
                itemLabelBuilder: (locale) => _localeLabels[locale] ?? locale,
                hintText: 'Select language and region',
                borderRadius: AppRadius.md,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ProfileSection(
          icon: Icons.shield_outlined,
          title: 'Verified account identity',
          subtitle:
              'These details are protected because they are used to sign in.',
          child: Column(
            children: [
              VerifiedIdentityCard(
                icon: Icons.phone_outlined,
                label: 'Verified phone',
                value: user.phone,
                description:
                    'Changing this number requires a secure OTP verification flow.',
              ),
              if (user.email != null) ...[
                const SizedBox(height: AppSpacing.md),
                VerifiedIdentityCard(
                  icon: Icons.email_outlined,
                  label: 'Account email',
                  value: user.email!,
                  description:
                      'This email is managed by your account authentication.',
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.colorTheme.primaryContainer,
                  borderRadius: AppRadius.field,
                ),
                child: Icon(icon, size: 19, color: context.colorTheme.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}
