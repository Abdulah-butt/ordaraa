import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/theme_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/assets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.showBackButton = true,
    this.leading,
    this.actions = const [],
    this.subtitle,
    this.trailing,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showBackButton;
  final Widget? leading;
  final List<Widget> actions;
  final String? subtitle;
  final Widget? trailing;

  static const double height = 44;
  static const double controlSize = 42;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final leadingWidget =
        leading ??
        (showBackButton
            ? _BackButton(
                onPressed: onBack ?? () => Navigator.maybePop(context),
              )
            : null);

    return SizedBox(
      height: height,
      child: Row(
        children: [
          if (leadingWidget != null) ...[
            SizedBox(
              width: controlSize,
              height: controlSize,
              child: leadingWidget,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    height: 26 / 18,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 11,
                      height: 16 / 11,
                      fontWeight: FontWeight.w400,
                      color: context.colorTheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.sm),
            ...actions,
          ],
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorTheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: context.colorTheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: SvgPicture.asset(Assets.chevronLeft, width: 18, height: 18),
          ),
        ),
      ),
    );
  }
}
