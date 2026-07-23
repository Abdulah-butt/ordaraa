import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/enums/payment_terms.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../widgets/custom_drop_down.dart';
import '../../../../widgets/custom_textfield.dart';
import '../organization_profile_cubit.dart';
import '../organization_profile_state.dart';
import 'organization_profile_section.dart';

class OrganizationProfileContent extends StatelessWidget {
  const OrganizationProfileContent({
    super.key,
    required this.cubit,
    required this.state,
  });

  final OrganizationProfileCubit cubit;
  final OrganizationProfileState state;

  @override
  Widget build(BuildContext context) {
    final organization = state.organization!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: AppSpacing.card,
          decoration: BoxDecoration(
            color: context.colorTheme.primaryContainer,
            borderRadius: AppRadius.card,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: context.colorTheme.primary,
                child: Text(
                  _initials(organization.name),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorTheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${organization.type.displayText} • ${organization.market.name}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (organization.verified)
                Tooltip(
                  message: 'Verified organization',
                  child: Icon(
                    Icons.verified_rounded,
                    color: context.colorTheme.primary,
                    size: 22,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OrganizationProfileSection(
          icon: Icons.storefront_outlined,
          title: 'Business information',
          subtitle: 'The business name customers and suppliers will see.',
          children: [
            CustomTextField(
              controller: cubit.nameController,
              label: 'Business name',
              hint: 'Enter business name',
              action: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(160)],
            ),
            CustomTextField(
              controller: cubit.legalNameController,
              label: 'Legal business name',
              hint: 'Enter registered legal name',
              action: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(200)],
              bottomPadding: 0,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        OrganizationProfileSection(
          icon: Icons.contact_phone_outlined,
          title: 'Contact information',
          subtitle: 'Used for order and account communication.',
          children: [
            CustomTextField(
              controller: cubit.contactNameController,
              label: 'Contact person',
              hint: 'Enter contact name',
              action: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(120)],
            ),
            CustomTextField(
              controller: cubit.contactEmailController,
              label: 'Contact email',
              hint: 'accounts@example.com',
              keyboard: TextInputType.emailAddress,
              action: TextInputAction.next,
            ),
            CustomTextField(
              controller: cubit.contactPhoneController,
              label: 'Contact phone',
              hint: '+61 412 345 678',
              keyboard: TextInputType.phone,
              inputFormatters: [LengthLimitingTextInputFormatter(32)],
              bottomPadding: 0,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        OrganizationProfileSection(
          icon: Icons.assignment_outlined,
          title: 'Tax and registration',
          subtitle: 'Official identifiers shown on business documents.',
          children: [
            CustomTextField(
              controller: cubit.registrationNumberController,
              label: 'Registration number',
              hint: 'For example, ABN 12 345 678 901',
              action: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(64)],
            ),
            CustomTextField(
              controller: cubit.taxNumberController,
              label: 'Tax number',
              hint: 'Enter tax or GST number',
              inputFormatters: [LengthLimitingTextInputFormatter(64)],
              bottomPadding: 0,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        OrganizationProfileSection(
          icon: Icons.receipt_long_outlined,
          title: 'Default payment terms',
          subtitle: 'Applied as the preferred terms for new transactions.',
          children: [
            CustomDropdown<PaymentTerms>(
              items: PaymentTerms.values,
              value: state.paymentTerms,
              onChanged: cubit.setPaymentTerms,
              itemLabelBuilder: (terms) => terms.displayText,
              hintText: 'Select payment terms',
              borderRadius: AppRadius.md,
            ),
          ],
        ),
      ],
    );
  }

  String _initials(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }
}
