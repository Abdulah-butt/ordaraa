import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extension.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String label;
  final String? subTitle;

  final TextStyle? labelStyle;
  final Color? activeColor;
  final Color? inactiveColor;
  final double spacing;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.subTitle,
    this.labelStyle,
    this.activeColor,
    this.inactiveColor,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (activeColor ?? theme.primaryColor)
                      : (inactiveColor ?? theme.dividerColor),
                  width: 2,
                ),
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? (activeColor ?? theme.primaryColor)
                      : Colors.transparent,
                ),
              ),
            ),
            SizedBox(width: spacing),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(label, style: labelStyle ?? theme.textTheme.bodyMedium),
                  subTitle == null
                      ? SizedBox.shrink()
                      : Text(
                          subTitle!,
                          style: context.textTheme.bodySmall?.copyWith(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
