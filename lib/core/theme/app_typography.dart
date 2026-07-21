import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// ORDARA type system — Manrope (Figma "01 — Foundations / Typography").
///
/// Figma → Material mapping:
///   Display Large 48/56 w800  → displayLarge
///   Heading 1     30/38 w700  → headlineLarge (+ displayMedium alias)
///   Heading 2     24/32 w700  → headlineMedium
///   Heading 3     20/28 w600  → headlineSmall / titleLarge
///   Body Large    16/24 w400  → bodyLarge
///   Body Medium   14/22 w400  → bodyMedium
///   Body Small    12/18 w400  → bodySmall
///   Label Large   14/20 w600  → labelLarge
///   Label Medium  12/18 w600 +0.1 → labelMedium
///   Label Small   11/16 w600 +0.2 → labelSmall
///   Data/KPI Large 32/38 w700 −0.2 → [kpiLarge]
abstract final class AppTypography {
  static String get fontFamily => GoogleFonts.manrope().fontFamily!;

  static TextTheme lightTextTheme() => _build(
        brightness: Brightness.light,
        primary: AppColors.lightTextPrimary,
        secondary: AppColors.lightTextSecondary,
        tertiary: AppColors.lightTextTertiary,
      );

  static TextTheme darkTextTheme() => _build(
        brightness: Brightness.dark,
        primary: AppColors.darkTextPrimary,
        secondary: AppColors.darkTextSecondary,
        tertiary: AppColors.darkTextTertiary,
      );

  static TextTheme _build({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color tertiary,
  }) {
    final base = brightness == Brightness.light
        ? Typography.material2021().black
        : Typography.material2021().white;
    final font = GoogleFonts.manropeTextTheme(base);

    return font.copyWith(
      // Ordara/Display Large — marketing & empty-state heroes.
      displayLarge: font.displayLarge?.copyWith(
        fontSize: 48,
        height: 56 / 48,
        fontWeight: FontWeight.w800,
        color: primary,
      ),
      // Alias of Heading 1 for widgets that reach for displayMedium.
      displayMedium: font.displayMedium?.copyWith(
        fontSize: 30,
        height: 38 / 30,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      displaySmall: font.displaySmall?.copyWith(
        fontSize: 26,
        height: 34 / 26,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // Ordara/Heading 1 — page titles.
      headlineLarge: font.headlineLarge?.copyWith(
        fontSize: 30,
        height: 38 / 30,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // Ordara/Heading 2 — section titles.
      headlineMedium: font.headlineMedium?.copyWith(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      // Ordara/Heading 3 — card/sheet titles, product names.
      headlineSmall: font.headlineSmall?.copyWith(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: font.titleLarge?.copyWith(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: font.titleMedium?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: font.titleSmall?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      // Ordara/Body — operational text.
      bodyLarge: font.bodyLarge?.copyWith(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: font.bodyMedium?.copyWith(
        fontSize: 14,
        height: 22 / 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      bodySmall: font.bodySmall?.copyWith(
        fontSize: 12,
        height: 18 / 12,
        fontWeight: FontWeight.w400,
        color: tertiary,
      ),
      // Ordara/Labels — buttons, chips, eyebrows.
      labelLarge: font.labelLarge?.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      labelMedium: font.labelMedium?.copyWith(
        fontSize: 12,
        height: 18 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: secondary,
      ),
      labelSmall: font.labelSmall?.copyWith(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: tertiary,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Commerce / data styles (no Material TextTheme slot)
  // ---------------------------------------------------------------------------

  /// Ordara/Data/KPI Large — 32/38 Bold −0.2, tabular figures.
  /// Dashboard KPI numbers and order totals ("AUD 84.00").
  static TextStyle kpiLarge(TextTheme textTheme) =>
      (textTheme.headlineMedium ?? const TextStyle()).copyWith(
        fontSize: 32,
        height: 38 / 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Product-card price — currency code stays visible
  /// ("AUD 84.00 / case") per the commerce formatting rules.
  static TextStyle price(TextTheme textTheme) =>
      (textTheme.titleLarge ?? const TextStyle()).copyWith(
        fontSize: 18,
        height: 26 / 18,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Money in running text/tables (tabular alignment).
  static TextStyle money(TextTheme textTheme) =>
      (textTheme.titleMedium ?? const TextStyle()).copyWith(
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Apply tabular figures to any style (quantities, order counts, tables).
  static TextStyle numeric(TextStyle base) => base.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
