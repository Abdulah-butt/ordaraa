import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/assets.dart';

class RoleOptionCard extends StatelessWidget {
  const RoleOptionCard({
    super.key,
    required this.label,
    required this.description,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$label. $description',
      hint: 'Double tap to continue',
      child: Material(
        color: selected
            ? context.colorTheme.primaryContainer
            : context.colorTheme.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(minHeight: 126),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? context.colorTheme.primary
                    : context.colorTheme.outlineVariant,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorTheme.shadow.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? context.colorTheme.surface
                        : context.colorTheme.primaryContainer.withValues(
                            alpha: 0.65,
                          ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Image.asset(
                    iconAsset,
                    width: 78,
                    height: 78,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    cacheWidth: 256,
                    excludeFromSemantics: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorTheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? context.colorTheme.primary
                        : context.colorTheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    Assets.chevronRight,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      selected
                          ? context.colorTheme.onPrimary
                          : context.colorTheme.onSurfaceVariant,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
