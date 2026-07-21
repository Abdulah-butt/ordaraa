import 'package:flutter/widgets.dart';

/// ORDARA spacing tokens.
///
/// Canonical Figma scale (space/50–800): 4 · 8 · 16 · 24 · 32 · 48 · 64.
/// `md` (12) and `xl` (20) are permitted in-between values for dense
/// component internals; page/section rhythm must stay on the canonical scale.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4; // space/50
  static const double sm = 8; // space/100
  static const double md = 12; // in-between (component internals only)
  static const double lg = 16; // space/200
  static const double xl = 20; // in-between (component internals only)
  static const double xxl = 24; // space/300
  static const double xxxl = 32; // space/400
  static const double massive = 48; // space/600
  static const double section = 64; // space/800

  static const EdgeInsets pageCompact = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets pageSmall = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets pageMedium = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets pageExpanded = EdgeInsets.symmetric(horizontal: xxxl);

  static const EdgeInsets card = EdgeInsets.all(lg);
  static const EdgeInsets cardCompact = EdgeInsets.all(md);
  static const EdgeInsets sheet = EdgeInsets.fromLTRB(lg, sm, lg, xxl);
}
