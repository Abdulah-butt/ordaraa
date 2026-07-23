import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_colors.dart';

class BuyerAccountProfileCard extends StatelessWidget {
  const BuyerAccountProfileCard({
    super.key,
    required this.displayName,
    required this.initials,
    required this.roleLabel,
    required this.onEdit,
  });

  final String displayName;
  final String initials;
  final String roleLabel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? context.colorTheme.primaryContainer
            : AppColors.brand50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? context.colorTheme.primary
                  : AppColors.brand600,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              initials,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorTheme.onPrimary,
                fontWeight: FontWeight.w700,
                height: 23 / 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      height: 22 / 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    roleLabel,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.onSurfaceVariant,
                      height: 18 / 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Edit personal profile',
            onPressed: onEdit,
            style: IconButton.styleFrom(
              minimumSize: const Size.square(40),
              maximumSize: const Size.square(40),
              backgroundColor: context.colorTheme.surface,
              foregroundColor: context.colorTheme.primary,
              side: BorderSide(color: context.colorTheme.outlineVariant),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
          ),
        ],
      ),
    );
  }
}
