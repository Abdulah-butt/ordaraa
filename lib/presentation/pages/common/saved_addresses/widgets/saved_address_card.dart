import 'package:flutter/material.dart';

import '../../../../../core/extensions/address_extension.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/enums/address_type.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/entities/address.dart';

class SavedAddressCard extends StatelessWidget {
  const SavedAddressCard({super.key, required this.address});

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: AppRadius.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: context.colorTheme.primaryContainer,
              borderRadius: AppRadius.field,
            ),
            child: Icon(
              _iconFor(address.type),
              size: 21,
              color: context.colorTheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        address.label ?? address.type.displayText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (address.isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.ordaraColors.successContainer,
                          borderRadius: AppRadius.chip,
                        ),
                        child: Text(
                          'Default',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.ordaraColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  address.type.displayText,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  address.displayAddress,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorTheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                if (address.contactName != null ||
                    address.contactPhone != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    [
                      if (address.contactName != null) address.contactName!,
                      if (address.contactPhone != null) address.contactPhone!,
                    ].join(' • '),
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(AddressType type) => switch (type) {
    AddressType.warehouse => Icons.warehouse_outlined,
    AddressType.billing => Icons.receipt_long_outlined,
    AddressType.registered => Icons.business_outlined,
    AddressType.delivery => Icons.local_shipping_outlined,
    AddressType.other => Icons.location_on_outlined,
  };
}
