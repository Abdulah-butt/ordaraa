import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/assets.dart';

class RoleOptionCard extends StatelessWidget {
  const RoleOptionCard({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected
            ? context.colorTheme.primaryContainer
            : context.colorTheme.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            height: 112,
            padding: const EdgeInsets.all(18),
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
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colorTheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(iconAsset, width: 28, height: 28),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(label, style: context.textTheme.titleLarge),
                ),
                SvgPicture.asset(Assets.chevronRight, width: 24, height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
