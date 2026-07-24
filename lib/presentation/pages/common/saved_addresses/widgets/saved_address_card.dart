import 'package:flutter/material.dart';

import '../../../../../core/extensions/address_extension.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/enums/address_type.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/entities/address.dart';

class SavedAddressCard extends StatelessWidget {
  const SavedAddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    this.deleting = false,
  });

  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool deleting;

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
                    const SizedBox(width: AppSpacing.xs),
                    _AddressMenu(
                      deleting: deleting,
                      onEdit: onEdit,
                      onDelete: onDelete,
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

enum _AddressMenuAction { edit, delete }

class _AddressMenu extends StatelessWidget {
  const _AddressMenu({
    required this.deleting,
    required this.onEdit,
    required this.onDelete,
  });

  final bool deleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    if (deleting) {
      return const SizedBox(
        width: 34,
        height: 34,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return PopupMenuButton<_AddressMenuAction>(
      tooltip: 'Address actions',
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert_rounded, size: 21),
      onSelected: (action) {
        switch (action) {
          case _AddressMenuAction.edit:
            onEdit();
            return;
          case _AddressMenuAction.delete:
            onDelete();
            return;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _AddressMenuAction.edit,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit address'),
          ),
        ),
        PopupMenuItem(
          value: _AddressMenuAction.delete,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: Icon(
              Icons.delete_outline_rounded,
              color: context.colorTheme.error,
            ),
            title: Text(
              'Delete address',
              style: TextStyle(color: context.colorTheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
