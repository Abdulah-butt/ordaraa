import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'ordara_theme_extension.dart';

/// ORDARA — Dark theme. Mirrors the light semantic mapping onto the Figma
/// neutral 950/900/800 stack; primary lifts to brand/500 for contrast.
ThemeData buildOrdaraDarkTheme() {
  final textTheme = AppTypography.darkTextTheme();
  const colorScheme = ColorScheme.dark(
    primary: AppColors.brand500,
    onPrimary: AppColors.neutral950,
    primaryContainer: AppColors.brand800,
    onPrimaryContainer: AppColors.brand100,
    secondary: AppColors.teal500,
    onSecondary: AppColors.neutral950,
    secondaryContainer: Color(0xFF0D4A45),
    onSecondaryContainer: AppColors.teal100,
    tertiary: AppColors.warningDark,
    onTertiary: AppColors.neutral950,
    tertiaryContainer: Color(0x26D97706),
    onTertiaryContainer: AppColors.amber100,
    error: AppColors.errorDark,
    onError: AppColors.neutral950,
    errorContainer: Color(0x26C33C45),
    onErrorContainer: AppColors.errorDark,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    onSurfaceVariant: AppColors.darkTextSecondary,
    surfaceContainerLowest: AppColors.neutral950,
    surfaceContainerLow: AppColors.neutral900,
    surfaceContainer: AppColors.neutral800,
    surfaceContainerHigh: AppColors.neutral700,
    surfaceContainerHighest: AppColors.neutral600,
    outline: AppColors.darkBorder,
    outlineVariant: AppColors.darkBorderSubtle,
    shadow: Color(0xB3000000),
    scrim: Color(0xCC000000),
    inverseSurface: AppColors.neutral50,
    onInverseSurface: AppColors.neutral900,
    inversePrimary: AppColors.brand700,
    surfaceTint: Colors.transparent,
  );

  final border = OutlineInputBorder(
    borderRadius: AppRadius.field,
    borderSide: const BorderSide(color: AppColors.darkBorder),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.fontFamily,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    canvasColor: AppColors.darkSurface,
    textTheme: textTheme,
    visualDensity: VisualDensity.standard,
    extensions: const <ThemeExtension<dynamic>>[OrdaraThemeColors.dark],
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: AppSpacing.lg,
      iconTheme: const IconThemeData(size: AppSizes.iconLg),
      titleTextStyle: textTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: const BorderSide(color: AppColors.darkBorderSubtle),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorderSubtle,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceMuted,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 14,
      ),
      border: border,
      enabledBorder: border,
      disabledBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.darkBorderSubtle),
      ),
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(
          color: AppColors.brand500,
          width: AppSizes.focusRingWidth,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.errorDark),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(
          color: AppColors.errorDark,
          width: AppSizes.focusRingWidth,
        ),
      ),
      labelStyle: textTheme.bodyMedium,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.darkTextTertiary,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.errorDark),
      prefixIconColor: AppColors.darkTextSecondary,
      suffixIconColor: AppColors.darkTextSecondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppSizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        backgroundColor: AppColors.brand500,
        foregroundColor: AppColors.neutral950,
        disabledBackgroundColor: AppColors.darkBorderSubtle,
        disabledForegroundColor: AppColors.darkTextDisabled,
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
        foregroundColor: AppColors.brand500,
        side: const BorderSide(color: AppColors.darkBorder),
        textStyle: textTheme.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
        foregroundColor: AppColors.brand500,
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
        foregroundColor: AppColors.darkTextPrimary,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurfaceMuted,
      selectedColor: AppColors.brand800,
      disabledColor: AppColors.darkBorderSubtle,
      side: const BorderSide(color: AppColors.darkBorderSubtle),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      labelStyle: textTheme.labelMedium,
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.brand100,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: AppSizes.bottomNavigationHeight,
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.brand800,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return textTheme.labelSmall?.copyWith(
          color: selected ? AppColors.brand100 : AppColors.darkTextTertiary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: AppSizes.iconLg,
          color: selected ? AppColors.brand500 : AppColors.darkTextTertiary,
        );
      }),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.brand800,
      selectedIconTheme: const IconThemeData(color: AppColors.brand500),
      unselectedIconTheme: const IconThemeData(
        color: AppColors.darkTextTertiary,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.brand100,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColors.darkSurface,
      showDragHandle: false,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurfaceElevated,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      actionTextColor: AppColors.brand500,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brand500,
      linearTrackColor: AppColors.darkBorderSubtle,
      circularTrackColor: AppColors.darkBorderSubtle,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.brand500,
      selectionHandleColor: AppColors.brand500,
      selectionColor: AppColors.brand500.withValues(alpha: 0.24),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: const BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: AppRadius.chip,
      ),
      textStyle: textTheme.bodySmall?.copyWith(
        color: AppColors.darkTextPrimary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.brand500,
      foregroundColor: AppColors.neutral950,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.brand500
            : AppColors.darkTextTertiary;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.neutral950
            : AppColors.darkTextTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected)
            ? AppColors.brand500
            : AppColors.darkBorder;
      }),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.darkSurfaceElevated,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
      textStyle: textTheme.bodyMedium,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      minVerticalPadding: AppSpacing.sm,
      iconColor: AppColors.darkTextSecondary,
      textColor: AppColors.darkTextPrimary,
      titleTextStyle: textTheme.titleSmall,
      subtitleTextStyle: textTheme.bodySmall,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
    ),
    dataTableTheme: DataTableThemeData(
      headingTextStyle: textTheme.labelMedium?.copyWith(
        color: AppColors.darkTextSecondary,
        fontWeight: FontWeight.w700,
      ),
      dataTextStyle: textTheme.bodyMedium,
      headingRowColor: const WidgetStatePropertyAll(AppColors.darkSurfaceMuted),
      dividerThickness: 1,
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: AppRadius.card,
      ),
    ),
  );
}
