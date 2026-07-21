import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'ordara_theme_extension.dart';

/// ORDARA — Light theme. Values come from Figma "01 — Foundations".
///
/// Semantic mapping:
///   primary   → brand/700   secondary → teal/600   tertiary → amber/600
///   surface   → white       background → neutral/50
///   text/primary → neutral/950   text/secondary → neutral/700
ThemeData buildOrdaraLightTheme() {
  final textTheme = AppTypography.lightTextTheme();
  const colorScheme = ColorScheme.light(
    primary: AppColors.brand700,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.brand100,
    onPrimaryContainer: AppColors.brand900,
    secondary: AppColors.teal600,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.teal100,
    onSecondaryContainer: AppColors.teal700,
    tertiary: AppColors.amber600,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.amber100,
    onTertiaryContainer: AppColors.amber600,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.errorBg,
    onErrorContainer: AppColors.error,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    onSurfaceVariant: AppColors.lightTextSecondary,
    surfaceContainerLowest: AppColors.white,
    surfaceContainerLow: AppColors.neutral50,
    surfaceContainer: AppColors.neutral100,
    surfaceContainerHigh: AppColors.neutral200,
    surfaceContainerHighest: AppColors.neutral300,
    outline: AppColors.lightBorder,
    outlineVariant: AppColors.lightBorderSubtle,
    shadow: Color(0x140B1220),
    scrim: Color(0x99000000),
    inverseSurface: AppColors.neutral900,
    onInverseSurface: AppColors.neutral50,
    inversePrimary: AppColors.brand500,
    surfaceTint: Colors.transparent,
  );

  final border = OutlineInputBorder(
    borderRadius: AppRadius.field,
    borderSide: const BorderSide(color: AppColors.lightBorder),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.fontFamily,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    canvasColor: AppColors.lightSurface,
    textTheme: textTheme,
    visualDensity: VisualDensity.standard,
    extensions: const <ThemeExtension<dynamic>>[
      OrdaraThemeColors.light,
    ],
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: AppSpacing.lg,
      iconTheme: const IconThemeData(size: AppSizes.iconLg),
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: const BorderSide(color: AppColors.lightBorderSubtle),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorderSubtle,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 14,
      ),
      border: border,
      enabledBorder: border,
      disabledBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.lightBorderSubtle),
      ),
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(
          color: AppColors.brand700,
          width: AppSizes.focusRingWidth,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(
          color: AppColors.error,
          width: AppSizes.focusRingWidth,
        ),
      ),
      labelStyle: textTheme.bodyMedium,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.lightTextTertiary,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
      prefixIconColor: AppColors.lightTextSecondary,
      suffixIconColor: AppColors.lightTextSecondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppSizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        backgroundColor: AppColors.brand700,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.neutral200,
        disabledForegroundColor: AppColors.neutral500,
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: textTheme.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppSizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        foregroundColor: AppColors.brand700,
        side: const BorderSide(color: AppColors.lightBorder),
        textStyle: textTheme.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
        foregroundColor: AppColors.brand700,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        textStyle: textTheme.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, AppSizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        textStyle: textTheme.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
        iconSize: AppSizes.iconLg,
        foregroundColor: AppColors.lightTextPrimary,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurfaceMuted,
      selectedColor: AppColors.brand100,
      disabledColor: AppColors.lightBorderSubtle,
      side: const BorderSide(color: AppColors.lightBorderSubtle),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      labelStyle: textTheme.labelMedium,
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.brand900,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: AppSizes.bottomNavigationHeight,
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.brand100,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return textTheme.labelSmall?.copyWith(
          color: selected ? AppColors.brand900 : AppColors.lightTextTertiary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: AppSizes.iconLg,
          color: selected ? AppColors.brand700 : AppColors.lightTextTertiary,
        );
      }),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: AppColors.brand100,
      selectedIconTheme: const IconThemeData(color: AppColors.brand700),
      unselectedIconTheme:
          const IconThemeData(color: AppColors.lightTextTertiary),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.brand900,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColors.lightSurface,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.neutral900,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.neutral50,
      ),
      actionTextColor: AppColors.brand500,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brand700,
      linearTrackColor: AppColors.lightBorderSubtle,
      circularTrackColor: AppColors.lightBorderSubtle,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.brand700,
      selectionHandleColor: AppColors.brand700,
      selectionColor: AppColors.brand700.withValues(alpha: 0.20),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: const BoxDecoration(
        color: AppColors.neutral900,
        borderRadius: AppRadius.chip,
      ),
      textStyle: textTheme.bodySmall?.copyWith(color: AppColors.neutral50),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.brand700,
      foregroundColor: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      side: const BorderSide(color: AppColors.lightBorder, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.brand700
            : AppColors.lightTextTertiary;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.white
            : AppColors.lightTextTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.brand700
            : AppColors.lightBorder;
      }),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
      textStyle: textTheme.bodyMedium,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      minVerticalPadding: AppSpacing.sm,
      iconColor: AppColors.lightTextSecondary,
      textColor: AppColors.lightTextPrimary,
      titleTextStyle: textTheme.titleSmall,
      subtitleTextStyle: textTheme.bodySmall,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
    ),
    dataTableTheme: DataTableThemeData(
      headingTextStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.lightTextSecondary,
        fontWeight: FontWeight.w700,
      ),
      dataTextStyle: textTheme.bodyMedium,
      headingRowColor: const WidgetStatePropertyAll(
        AppColors.lightSurfaceMuted,
      ),
      dividerThickness: 1,
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: AppRadius.card,
      ),
    ),
  );
}
