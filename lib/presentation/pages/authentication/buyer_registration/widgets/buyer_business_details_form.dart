import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../domain/entities/market.dart';
import '../../../../widgets/custom_drop_down.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../widgets/verified_phone_card.dart';
import '../buyer_registration_cubit.dart';
import '../buyer_registration_state.dart';

class BuyerBusinessDetailsForm extends StatelessWidget {
  const BuyerBusinessDetailsForm({
    super.key,
    required this.cubit,
    required this.state,
  });

  final BuyerRegistrationCubit cubit;
  final BuyerRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final fieldStyle = context.textTheme.labelMedium?.copyWith(
      color: context.colorTheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tell us about your business',
          style: context.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Only these details are needed to start ordering.',
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        _Field(
          label: 'Business name',
          controller: cubit.businessNameController,
          labelStyle: fieldStyle,
        ),
        const SizedBox(height: 14),
        CustomDropdown<Market>(
          label: 'Market',
          value: state.selectedMarket,
          items: cubit.markets,
          hintText: state.loadingMarkets
              ? 'Loading markets...'
              : 'Select market',
          disable: state.loadingMarkets,
          itemLabelBuilder: (market) => market.name,
          onChanged: cubit.setMarket,
          height: 48,
          borderRadius: 10,
          borderColor: context.colorTheme.outline,
          fillColor: context.colorTheme.surface,
          labelSpacing: 6,
          labelStyle: fieldStyle,
        ),
        const SizedBox(height: 14),
        _Field(
          label: 'Delivery address',
          hint: 'Street address',
          controller: cubit.addressLine1Controller,
          labelStyle: fieldStyle,
          action: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        _Field(
          label: 'City',
          controller: cubit.cityController,
          labelStyle: fieldStyle,
          action: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _Field(
                label: 'State/region',
                controller: cubit.stateController,
                labelStyle: fieldStyle,
                action: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Field(
                label: 'Postal code',
                controller: cubit.postalCodeController,
                labelStyle: fieldStyle,
                keyboard: TextInputType.streetAddress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        VerifiedPhoneCard(
          phoneNumber: cubit.phoneNumber,
          description: 'Verified WhatsApp · Order updates sent here',
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.labelStyle,
    this.hint = '',
    this.action,
    this.keyboard,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextStyle? labelStyle;
  final TextInputAction? action;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: hint,
      controller: controller,
      height: 48,
      bottomPadding: 0,
      borderRadius: 10,
      borderColor: context.colorTheme.outline,
      fillColor: context.colorTheme.surface,
      labelSpacing: 6,
      labelStyle: labelStyle,
      action: action,
      keyboard: keyboard,
    );
  }
}
