import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../domain/entities/market.dart';
import '../../../../widgets/custom_drop_down.dart';
import '../../../../widgets/custom_textfield.dart';
import '../seller_registration_cubit.dart';
import '../seller_registration_state.dart';

class SellerBusinessDetailsStep extends StatelessWidget {
  const SellerBusinessDetailsStep({
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
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colorTheme.primaryContainer.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(Assets.roleSeller, width: 24, height: 24),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Tell us about your business',
          style: context.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Only the details needed to identify the supplier business.',
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        CustomTextField(
          label: 'Legal business name',
          controller: cubit.legalNameController,
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
          label: 'Trading name (optional)',
          controller: cubit.tradingNameController,
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
          label: 'ABN / ACN',
          controller: cubit.abnController,
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
          labelStyle: context.textTheme.labelMedium?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
