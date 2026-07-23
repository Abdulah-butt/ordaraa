import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/address_extension.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/entities/address.dart';

class CheckoutAddressSheet extends StatelessWidget {
  const CheckoutAddressSheet({
    super.key,
    required this.addresses,
    required this.selectedAddress,
  });

  final List<Address> addresses;
  final Address? selectedAddress;

  @override
  Widget build(BuildContext context) {
    final height = (140.0 + (addresses.length * 104.0))
        .clamp(260.0, MediaQuery.sizeOf(context).height * 0.68)
        .toDouble();
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose delivery address',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Select where this supplier should deliver the order.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              itemCount: addresses.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final address = addresses[index];
                final selected = address.id == selectedAddress?.id;
                return Material(
                  color: selected
                      ? context.colorTheme.primaryContainer
                      : context.colorTheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.field,
                    side: BorderSide(
                      color: selected
                          ? context.colorTheme.primary
                          : context.colorTheme.outlineVariant,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => context.pop(address),
                    borderRadius: AppRadius.field,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: context.colorTheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.label ?? address.type.apiValue,
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  address.displayAddress,
                                  style: context.textTheme.bodySmall,
                                ),
                                if (address.contactName != null) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Contact: ${address.contactName}',
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(
                                          color: context
                                              .colorTheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: selected
                                ? context.colorTheme.primary
                                : context.colorTheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
