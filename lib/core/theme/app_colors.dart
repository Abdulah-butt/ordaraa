import 'package:flutter/material.dart';

/// Raw ORDARA design tokens — extracted from Figma "01 — Foundations".
///
/// Feature widgets should normally use [ColorScheme] and [OrdaraThemeColors]
/// from the active theme rather than referencing these constants directly.
/// If Figma and this file ever disagree, fix this file — never invent values.
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Brand ramp (Figma: brand/50–900)
  // ---------------------------------------------------------------------------
  static const Color brand900 = Color(0xFF102A43);
  static const Color brand800 = Color(0xFF163A5F);
  static const Color brand700 = Color(0xFF185C8D); // primary (light)
  static const Color brand600 = Color(0xFF1976B9);
  static const Color brand500 = Color(0xFF2B8AD0); // primary (dark)
  static const Color brand100 = Color(0xFFDCEFFC);
  static const Color brand50 = Color(0xFFF2F9FE);

  // ---------------------------------------------------------------------------
  // Teal ramp (Figma: teal/50–700) — supplier / freshness accent
  // ---------------------------------------------------------------------------
  static const Color teal700 = Color(0xFF087F78);
  static const Color teal600 = Color(0xFF0A9B91);
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal100 = Color(0xFFCCFBF1);
  static const Color teal50 = Color(0xFFF0FDFA);

  // ---------------------------------------------------------------------------
  // Amber ramp (Figma: amber/100–600) — attention / market highlight
  // ---------------------------------------------------------------------------
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber100 = Color(0xFFFEF3C7);

  // ---------------------------------------------------------------------------
  // Neutral ramp (Figma: neutral/50–950)
  // ---------------------------------------------------------------------------
  static const Color neutral950 = Color(0xFF0B1220);
  static const Color neutral900 = Color(0xFF172033);
  static const Color neutral800 = Color(0xFF293548);
  static const Color neutral700 = Color(0xFF465569);
  static const Color neutral600 = Color(0xFF637083);
  static const Color neutral500 = Color(0xFF8491A3);
  static const Color neutral400 = Color(0xFFAAB4C2);
  static const Color neutral300 = Color(0xFFCBD3DD);
  static const Color neutral200 = Color(0xFFE1E6ED);
  static const Color neutral100 = Color(0xFFEEF2F6);
  static const Color neutral50 = Color(0xFFF7F9FB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  // Light semantic aliases (mapped from the neutral ramp)
  // ---------------------------------------------------------------------------
  static const Color lightBackground = neutral50;
  static const Color lightSurface = white;
  static const Color lightSurfaceMuted = neutral100;
  static const Color lightSurfaceElevated = white;
  static const Color lightBorder = neutral300;
  static const Color lightBorderSubtle = neutral200;
  static const Color lightTextPrimary = neutral950; // Figma text/primary
  static const Color lightTextSecondary = neutral700; // Figma text/secondary
  static const Color lightTextTertiary = neutral500;
  static const Color lightTextDisabled = neutral400;

  // ---------------------------------------------------------------------------
  // Dark semantic aliases (neutral ramp inverted onto 950/900/800 stack)
  // ---------------------------------------------------------------------------
  static const Color darkBackground = neutral950;
  static const Color darkSurface = neutral900;
  static const Color darkSurfaceMuted = neutral800;
  static const Color darkSurfaceElevated = neutral800;
  static const Color darkBorder = neutral700;
  static const Color darkBorderSubtle = neutral800;
  static const Color darkTextPrimary = neutral50;
  static const Color darkTextSecondary = neutral300;
  static const Color darkTextTertiary = neutral500;
  static const Color darkTextDisabled = neutral600;

  // ---------------------------------------------------------------------------
  // Status (Figma: status/* + soft -bg pairs). Colour is never the only
  // signal — always pair with a text label (Confirmed, Overdue, Out of Stock).
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF17845B);
  static const Color successBg = Color(0xFFE8F7F0);
  static const Color warning = Color(0xFFB86B00);
  static const Color warningBg = Color(0xFFFFF4D6);
  static const Color error = Color(0xFFC33C45);
  static const Color errorBg = Color(0xFFFDECEE);
  static const Color info = Color(0xFF1769AA);
  static const Color infoBg = Color(0xFFE8F3FC);

  // Status variants lifted for contrast on dark surfaces.
  static const Color successDark = Color(0xFF34C08A);
  static const Color warningDark = Color(0xFFF0A93C);
  static const Color errorDark = Color(0xFFE4626C);
  static const Color infoDark = Color(0xFF5AA9E6);

  // ---------------------------------------------------------------------------
  // Role accents — mapped strictly onto Figma ramps (no invented palettes).
  // buyer → brand, supplier → teal, market → amber.
  // ---------------------------------------------------------------------------
  static const Color buyer = brand700;
  static const Color buyerContainer = brand100;
  static const Color supplier = teal600;
  static const Color supplierContainer = teal100;
  static const Color market = amber600;
  static const Color marketContainer = amber100;
}
