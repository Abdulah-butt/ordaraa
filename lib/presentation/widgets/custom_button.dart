import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extension.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final bool isDisabled;
  final bool isLoading;
  final bool isSecondary;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? leadingIcon;
  final double iconSpacing;
  final TextStyle? textStyle;
  final BorderSide? borderSide;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    this.onTap,
    this.text,
    this.isDisabled = false,
    this.isLoading = false,
    this.isSecondary = false,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.leadingIcon,
    this.iconSpacing = 8,
    this.textStyle,
    this.borderSide,
    this.boxShadow,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(16);
    final colorScheme = context.themeData.colorScheme;
    final isEffectivelyDisabled = isDisabled;
    final effectiveBackgroundColor = isEffectivelyDisabled
        ? Colors.grey.shade300
        : (backgroundColor ?? (isSecondary ? colorScheme.surface : null));
    final effectiveForegroundColor = isEffectivelyDisabled
        ? Colors.grey.shade500
        : (foregroundColor ?? (isSecondary ? colorScheme.onSurface : null));
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, height ?? 56),
        maximumSize: Size(width ?? double.infinity, height ?? 56),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        padding: padding,
        side:
            borderSide ??
            (isSecondary
                ? BorderSide(color: colorScheme.outlineVariant)
                : null),
      ),
      onPressed: (isDisabled || isLoading) ? null : onTap,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  effectiveForegroundColor ??
                      (isSecondary
                          ? colorScheme.onSurface
                          : colorScheme.onPrimary),
                ),
              ),
            )
          : (leadingIcon == null
                ? Text(
                    text ?? "",
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      leadingIcon!,
                      SizedBox(width: iconSpacing),
                      Text(
                        text ?? "",
                        style: textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
    );

    if (boxShadow == null || boxShadow!.isEmpty) {
      return button;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(borderRadius: borderRadius, child: button),
    );
  }
}
