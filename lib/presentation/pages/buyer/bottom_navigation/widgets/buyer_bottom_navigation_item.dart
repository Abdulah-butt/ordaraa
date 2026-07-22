import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/theme_extension.dart';

class BuyerBottomNavigationItem extends StatelessWidget {
  const BuyerBottomNavigationItem({
    super.key,
    required this.asset,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String asset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.colorTheme.primary
        : context.colorTheme.onSurfaceVariant;

    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: Material(
        color: isSelected
            ? context.ordaraColors.buyerContainer
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 76,
            height: 54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  asset,
                  width: 21,
                  height: 21,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontSize: 9,
                    height: 13 / 9,
                    fontWeight: FontWeight.w600,
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
