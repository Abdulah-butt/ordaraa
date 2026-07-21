import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../widgets/verified_phone_card.dart';
import '../seller_registration_cubit.dart';
import '../seller_registration_state.dart';

class SellerVerificationStep extends StatelessWidget {
  const SellerVerificationStep({
    super.key,
    required this.cubit,
    required this.state,
  });

  final SellerRegistrationCubit cubit;
  final SellerRegistrationState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Container(
        //     width: 64,
        //     height: 64,
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //       color: context.ordaraColors.supplierContainer.withValues(
        //         alpha: 0.45,
        //       ),
        //       shape: BoxShape.circle,
        //     ),
        //     child: SvgPicture.asset(Assets.account, width: 24, height: 24),
        //   ),
        // ),
        // const SizedBox(height: 14),
        // Text('Verify your business', style: context.textTheme.headlineMedium),
        // const SizedBox(height: 8),
        Text(
          'One contact, one address and one supporting document.',
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        CustomTextField(
          label: 'Your full name',
          controller: cubit.fullNameController,
          height: 48,
          bottomPadding: 0,
          borderRadius: 10,
          borderColor: context.colorTheme.outline,
          fillColor: context.colorTheme.surface,
          labelSpacing: 6,
          labelStyle: context.textTheme.labelMedium?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        CustomTextField(
          label: 'Registered business address',
          controller: cubit.addressController,
          height: 48,
          bottomPadding: 0,
          borderRadius: 10,
          borderColor: context.colorTheme.outline,
          fillColor: context.colorTheme.surface,
          labelSpacing: 6,
          labelStyle: context.textTheme.labelMedium?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        VerifiedPhoneCard(
          phoneNumber: cubit.phoneNumber,
          description: 'Verified WhatsApp · Updates will be sent here',
          height: 72,
        ),
        const SizedBox(height: 16),
        _DocumentUploadCard(cubit: cubit, uploaded: state.documentUploaded),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: Material(
            color: context.colorTheme.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: context.colorTheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CheckboxListTile(
              value: state.authorised,
              onChanged: cubit.toggleAuthorised,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              title: Text(
                'I am authorised to register this business.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorTheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  const _DocumentUploadCard({required this.cubit, required this.uploaded});

  final SellerRegistrationCubit cubit;
  final bool uploaded;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        border: Border.all(color: context.colorTheme.outline),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SvgPicture.asset(Assets.document, width: 24, height: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business registration or ABN document',
                  style: context.textTheme.labelLarge?.copyWith(fontSize: 13),
                ),
                Text(
                  'PDF, JPG or PNG · One file only',
                  style: context.textTheme.bodySmall,
                ),
                const Spacer(),
                CustomButton(
                  text: uploaded ? 'Document selected' : 'Upload document',
                  onTap: cubit.selectDocument,
                  isSecondary: true,
                  width: 160,
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  borderRadius: BorderRadius.circular(10),
                  foregroundColor: context.colorTheme.primary,
                  textStyle: context.textTheme.labelLarge?.copyWith(
                    color: context.colorTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
