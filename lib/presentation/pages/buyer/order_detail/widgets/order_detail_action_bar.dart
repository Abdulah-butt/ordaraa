import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../widgets/custom_button.dart';

class OrderDetailActionBar extends StatelessWidget {
  const OrderDetailActionBar({super.key, required this.onContactSupplier});

  final VoidCallback onContactSupplier;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border(
          top: BorderSide(color: context.colorTheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: CustomButton(
            text: 'Contact supplier',
            height: AppSizes.buttonHeight,
            isSecondary: true,
            borderSide: BorderSide(color: context.colorTheme.primary),
            foregroundColor: context.colorTheme.primary,
            borderRadius: BorderRadius.circular(10),
            leadingIcon: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: AppSizes.iconSm,
            ),
            onTap: onContactSupplier,
          ),
        ),
      ),
    );
  }
}
