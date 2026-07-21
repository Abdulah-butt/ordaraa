/// ORDARA sizing tokens.
///
/// Figma accessibility foundation: interactive controls must be at least
/// 44 × 44 on mobile. [touchTarget] uses 48 to exceed that minimum on the
/// 8-pt grid; never go below [minTouchTarget].
abstract final class AppSizes {
  // Icons
  static const double iconXs = 14;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 28;
  static const double iconXxl = 32;

  // Controls
  static const double controlSmall = 40;
  static const double controlMedium = 48;
  static const double controlLarge = 56;
  static const double buttonHeight = 48;
  static const double textFieldHeight = 48;
  static const double searchFieldHeight = 48;
  static const double minTouchTarget = 44; // Figma hard minimum
  static const double touchTarget = 48;
  static const double focusRingWidth = 2; // Figma: 2px brand focus ring

  // Layout
  static const double formMaxWidth = 480;
  static const double readableContentMaxWidth = 720;
  static const double pageMaxWidth = 1200;
  static const double bottomNavigationHeight = 72;

  // Media
  static const double avatarSmall = 32;
  static const double avatarMedium = 40;
  static const double avatarLarge = 56;
  static const double productThumbnail = 72;
}
