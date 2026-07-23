import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic colors beyond Material's [ColorScheme], theme-aware via
/// `context.ordaraColors`.
///
/// Status colors come from Figma status/* tokens. Role accents map strictly
/// onto Figma ramps (buyer → brand, supplier → teal, market → amber) — no
/// invented palettes. Colour is never the only signal: pair every status
/// colour with a text label ("Confirmed", "Overdue", "Out of Stock").
@immutable
class OrdaraThemeColors extends ThemeExtension<OrdaraThemeColors> {
  const OrdaraThemeColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.buyer,
    required this.buyerContainer,
    required this.supplier,
    required this.supplierContainer,
    required this.market,
    required this.marketContainer,
    required this.borderSubtle,
    required this.surfaceMuted,
    required this.surfaceElevated,
    required this.textTertiary,
    required this.textDisabled,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;

  final Color buyer;
  final Color buyerContainer;
  final Color supplier;
  final Color supplierContainer;
  final Color market;
  final Color marketContainer;

  final Color borderSubtle;
  final Color surfaceMuted;
  final Color surfaceElevated;
  final Color textTertiary;
  final Color textDisabled;
  final Color shimmerBase;
  final Color shimmerHighlight;

  static const light = OrdaraThemeColors(
    success: AppColors.success,
    onSuccess: AppColors.white,
    successContainer: AppColors.successBg,
    warning: AppColors.warning,
    onWarning: AppColors.white,
    warningContainer: AppColors.warningBg,
    info: AppColors.info,
    onInfo: AppColors.white,
    infoContainer: AppColors.infoBg,
    buyer: AppColors.buyer,
    buyerContainer: AppColors.buyerContainer,
    supplier: AppColors.supplier,
    supplierContainer: AppColors.supplierContainer,
    market: AppColors.market,
    marketContainer: AppColors.marketContainer,
    borderSubtle: AppColors.lightBorderSubtle,
    surfaceMuted: AppColors.lightSurfaceMuted,
    surfaceElevated: AppColors.lightSurfaceElevated,
    textTertiary: AppColors.lightTextTertiary,
    textDisabled: AppColors.lightTextDisabled,
    shimmerBase: AppColors.neutral200,
    shimmerHighlight: AppColors.neutral50,
  );

  static const dark = OrdaraThemeColors(
    success: AppColors.successDark,
    onSuccess: AppColors.neutral950,
    successContainer: Color(0x2617845B),
    warning: AppColors.warningDark,
    onWarning: AppColors.neutral950,
    warningContainer: Color(0x26B86B00),
    info: AppColors.infoDark,
    onInfo: AppColors.neutral950,
    infoContainer: Color(0x261769AA),
    buyer: AppColors.brand500,
    buyerContainer: AppColors.brand800,
    supplier: AppColors.teal500,
    supplierContainer: Color(0xFF0D4A45),
    market: AppColors.warningDark,
    marketContainer: Color(0x26D97706),
    borderSubtle: AppColors.darkBorderSubtle,
    surfaceMuted: AppColors.darkSurfaceMuted,
    surfaceElevated: AppColors.darkSurfaceElevated,
    textTertiary: AppColors.darkTextTertiary,
    textDisabled: AppColors.darkTextDisabled,
    shimmerBase: AppColors.neutral800,
    shimmerHighlight: AppColors.neutral700,
  );

  @override
  OrdaraThemeColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? buyer,
    Color? buyerContainer,
    Color? supplier,
    Color? supplierContainer,
    Color? market,
    Color? marketContainer,
    Color? borderSubtle,
    Color? surfaceMuted,
    Color? surfaceElevated,
    Color? textTertiary,
    Color? textDisabled,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return OrdaraThemeColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      buyer: buyer ?? this.buyer,
      buyerContainer: buyerContainer ?? this.buyerContainer,
      supplier: supplier ?? this.supplier,
      supplierContainer: supplierContainer ?? this.supplierContainer,
      market: market ?? this.market,
      marketContainer: marketContainer ?? this.marketContainer,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  OrdaraThemeColors lerp(covariant OrdaraThemeColors? other, double t) {
    if (other == null) return this;
    return OrdaraThemeColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      buyer: Color.lerp(buyer, other.buyer, t)!,
      buyerContainer: Color.lerp(buyerContainer, other.buyerContainer, t)!,
      supplier: Color.lerp(supplier, other.supplier, t)!,
      supplierContainer: Color.lerp(
        supplierContainer,
        other.supplierContainer,
        t,
      )!,
      market: Color.lerp(market, other.market, t)!,
      marketContainer: Color.lerp(marketContainer, other.marketContainer, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
    );
  }
}
