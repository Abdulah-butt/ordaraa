import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/theme_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/custom_button.dart';

enum ConfirmationSheetType { standard, warning, destructive }

class ConfirmationSheet extends StatelessWidget {
  const ConfirmationSheet({super.key, required this.initialParams});

  final ConfirmationSheetInitialParams initialParams;

  @override
  Widget build(BuildContext context) {
    final visualStyle = _visualStyle(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ConfirmationIllustration(
            icon: initialParams.icon ?? visualStyle.defaultIcon,
            foregroundColor: visualStyle.foregroundColor,
            backgroundColor: visualStyle.backgroundColor,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            initialParams.title,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (initialParams.subTitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                initialParams.subTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                  height: 22 / 14,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxxl),
          CustomButton(
            text: initialParams.primaryBtnText,
            height: AppSizes.buttonHeight,
            borderRadius: AppRadius.button,
            backgroundColor: visualStyle.actionColor,
            foregroundColor: visualStyle.actionForegroundColor,
            leadingIcon: Icon(
              initialParams.primaryButtonIcon ?? visualStyle.defaultIcon,
              size: AppSizes.iconMd,
            ),
            textStyle: context.textTheme.labelLarge?.copyWith(
              color: visualStyle.actionForegroundColor,
              fontWeight: FontWeight.w700,
            ),
            onTap: () {
              context.pop();
              initialParams.btnAction?.call();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomButton(
            text: initialParams.secondaryBtnText,
            height: AppSizes.buttonHeight,
            borderRadius: AppRadius.button,
            isSecondary: true,
            backgroundColor: context.colorTheme.surface,
            foregroundColor: context.colorTheme.onSurface,
            textStyle: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            onTap: context.pop,
          ),
        ],
      ),
    );
  }

  _ConfirmationVisualStyle _visualStyle(BuildContext context) {
    return switch (initialParams.type) {
      ConfirmationSheetType.destructive => _ConfirmationVisualStyle(
        foregroundColor: context.colorTheme.error,
        backgroundColor: context.colorTheme.errorContainer,
        actionColor: context.colorTheme.error,
        actionForegroundColor: context.colorTheme.onError,
        defaultIcon: Icons.delete_forever_rounded,
      ),
      ConfirmationSheetType.warning => _ConfirmationVisualStyle(
        foregroundColor: context.ordaraColors.warning,
        backgroundColor: context.ordaraColors.warningContainer,
        actionColor: context.ordaraColors.warning,
        actionForegroundColor: context.ordaraColors.onWarning,
        defaultIcon: Icons.warning_amber_rounded,
      ),
      ConfirmationSheetType.standard => _ConfirmationVisualStyle(
        foregroundColor: context.colorTheme.primary,
        backgroundColor: context.colorTheme.primaryContainer,
        actionColor: context.colorTheme.primary,
        actionForegroundColor: context.colorTheme.onPrimary,
        defaultIcon: Icons.help_outline_rounded,
      ),
    };
  }
}

class _ConfirmationIllustration extends StatelessWidget {
  const _ConfirmationIllustration({
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor.withValues(alpha: 0.42),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: foregroundColor.withValues(alpha: 0.18)),
        ),
        child: Icon(icon, size: 36, color: foregroundColor),
      ),
    );
  }
}

class _ConfirmationVisualStyle {
  const _ConfirmationVisualStyle({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.actionColor,
    required this.actionForegroundColor,
    required this.defaultIcon,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final Color actionColor;
  final Color actionForegroundColor;
  final IconData defaultIcon;
}

class ConfirmationSheetInitialParams {
  const ConfirmationSheetInitialParams({
    required this.title,
    required this.primaryBtnText,
    required this.secondaryBtnText,
    this.btnAction,
    this.subTitle = '',
    this.type = ConfirmationSheetType.standard,
    this.icon,
    this.primaryButtonIcon,
  });

  final String title;
  final String primaryBtnText;
  final String secondaryBtnText;
  final VoidCallback? btnAction;
  final String subTitle;
  final ConfirmationSheetType type;
  final IconData? icon;
  final IconData? primaryButtonIcon;
}
