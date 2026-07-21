import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

abstract final class AppTheme {
  static final ThemeData light = buildOrdaraLightTheme();
  static final ThemeData dark = buildOrdaraDarkTheme();
}
