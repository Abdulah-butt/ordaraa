import 'package:flutter/material.dart';

import '../extensions/theme_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable composed styles that are not already represented by ThemeData.
///
/// Prefer ThemeData, ColorScheme, TextTheme, and design tokens first.
abstract final class AppStyle {
  static InputBorder formFieldBorder(
    BuildContext context, {
    double radius = AppRadius.md,
    Color? borderColor,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? context.colorTheme.outline,
        width: width,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static TextStyle labelStyle(BuildContext context) =>
      (context.textTheme.labelMedium ?? const TextStyle()).copyWith(
        color: context.colorTheme.onSurface,
        fontWeight: FontWeight.w700,
      );

  static TextStyle textFieldTextStyle(
    BuildContext context, {
    bool isDisabled = false,
  }) => (context.textTheme.bodyLarge ?? const TextStyle()).copyWith(
    color: isDisabled
        ? context.ordaraColors.textDisabled
        : context.colorTheme.onSurface,
  );

  static EdgeInsetsGeometry centeredContentPadding({
    required double height,
    required TextStyle? textStyle,
    double horizontal = AppSpacing.md,
  }) {
    final fontSize = textStyle?.fontSize ?? 16;
    final lineHeight = (textStyle?.height ?? 1.2) * fontSize;
    final vertical = ((height - lineHeight) / 2).clamp(0.0, height);
    return EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
  }

  static InputDecoration textFieldDecoration(
    BuildContext context, {
    required String hint,
    TextStyle? hintStyle,
    EdgeInsetsGeometry? contentPadding,
    double radius = AppRadius.md,
    Color? borderColor,
    double borderWidth = 1,
    Color? fillColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    BoxConstraints? prefixIconConstraints,
    BoxConstraints? suffixIconConstraints,
    bool dense = true,
    bool transparentBorder = false,
    Duration? hintFadeDuration,
  }) {
    final border = formFieldBorder(
      context,
      radius: radius,
      borderColor: transparentBorder
          ? Colors.transparent
          : borderColor ?? context.colorTheme.outline,
      width: transparentBorder ? 0 : borderWidth,
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: hintStyle ?? textFieldHintStyle(context),
      hintFadeDuration: hintFadeDuration,
      filled: true,
      fillColor: fillColor ?? context.colorTheme.surface,
      contentPadding:
          contentPadding ??
          centeredContentPadding(
            height: AppSizes.textFieldHeight,
            textStyle: context.textTheme.bodyLarge,
            horizontal: AppSpacing.lg,
          ),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: context.colorTheme.primary,
          // Figma accessibility foundation: 2px brand focus ring.
          width: transparentBorder ? 0 : AppSizes.focusRingWidth,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(
          color: context.colorTheme.error,
          width: transparentBorder ? 0 : 1,
        ),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(
          color: context.colorTheme.error,
          width: transparentBorder ? 0 : AppSizes.focusRingWidth,
        ),
      ),
      isDense: dense,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconConstraints: prefixIconConstraints,
      suffixIconConstraints: suffixIconConstraints,
    );
  }

  static TextStyle textFieldHintStyle(BuildContext context) =>
      (context.textTheme.bodyMedium ?? const TextStyle()).copyWith(
        fontWeight: FontWeight.w400,
        color: context.ordaraColors.textTertiary,
      );

  // ---------------------------------------------------------------------------
  // Auth & page text roles
  // ---------------------------------------------------------------------------

  static TextStyle authHeading(BuildContext context) =>
      context.textTheme.headlineMedium ?? const TextStyle(); // Heading 2

  static TextStyle authSubHeading(BuildContext context) =>
      context.textTheme.bodyMedium ?? const TextStyle();

  static LinearGradient authBackgroundGradient(BuildContext context) =>
      LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          context.colorTheme.primaryContainer.withValues(alpha: 0.72),
          context.colorTheme.surface,
        ],
      );

  static TextStyle pageHeading(BuildContext context) =>
      context.textTheme.headlineLarge ?? const TextStyle(); // Heading 1

  static TextStyle pageBody(BuildContext context) =>
      (context.textTheme.bodyMedium ?? const TextStyle()).copyWith(
        color: context.ordaraColors.textTertiary,
      );

  static TextStyle detailPageHeading(BuildContext context) =>
      context.textTheme.titleLarge ?? const TextStyle(); // Heading 3

  static TextStyle detailPageSubHeading(BuildContext context) =>
      context.textTheme.titleMedium ?? const TextStyle();

  static TextStyle filterSheetTitle(BuildContext context) =>
      (context.textTheme.titleMedium ?? const TextStyle()).copyWith(
        fontWeight: FontWeight.w700,
      );

  // ---------------------------------------------------------------------------
  // Commerce text roles (Figma: "Commerce formatting")
  // ---------------------------------------------------------------------------

  /// KPI numbers on dashboards, order totals — "AUD 84.00".
  static TextStyle kpiLarge(BuildContext context) =>
      AppTypography.kpiLarge(context.textTheme);

  /// Product-card price — currency code stays visible ("AUD 84.00 / case").
  static TextStyle price(BuildContext context) =>
      AppTypography.price(context.textTheme);

  // ---------------------------------------------------------------------------
  // Gradients & decoration
  // ---------------------------------------------------------------------------

  /// Brand hero gradient: brand/800 → brand/600 (Figma ramp only).
  static LinearGradient brandGradient(BuildContext context) =>
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.brand800, AppColors.brand600],
      );

  /// Dark scrim over supplier/product imagery for legible overlay text.
  static LinearGradient imageTopOverlay(BuildContext context) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.black.withValues(alpha: 0.70), Colors.transparent],
    stops: const [0, 1],
  );

  static List<BoxShadow> cardShadow(BuildContext context) => [
    BoxShadow(
      color: context.colorTheme.shadow.withValues(
        alpha: context.isDarkMode ? 0.28 : 0.08,
      ),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static BoxDecoration elevatedSurface(BuildContext context) => BoxDecoration(
    color: context.ordaraColors.surfaceElevated,
    borderRadius: AppRadius.card,
    border: Border.all(color: context.ordaraColors.borderSubtle),
    boxShadow: cardShadow(context),
  );
}
