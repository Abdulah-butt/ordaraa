import 'package:flutter/material.dart';

import '../theme/ordara_theme_extension.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);
  ColorScheme get colorTheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  OrdaraThemeColors get ordaraColors {
    final extension = Theme.of(this).extension<OrdaraThemeColors>();
    assert(extension != null, 'OrdaraThemeColors is missing from ThemeData.');
    return extension ?? OrdaraThemeColors.light;
  }

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
