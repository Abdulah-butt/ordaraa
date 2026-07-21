import 'package:flutter/widgets.dart';

abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double expanded = 1024;

  static bool isCompact(double width) => width < compact;
  static bool isMedium(double width) => width >= compact && width < expanded;
  static bool isExpanded(double width) => width >= expanded;
}

enum AppWindowClass { compact, medium, expanded }

extension AppWindowClassContext on BuildContext {
  AppWindowClass get windowClass {
    final width = MediaQuery.sizeOf(this).width;
    if (AppBreakpoints.isCompact(width)) return AppWindowClass.compact;
    if (AppBreakpoints.isMedium(width)) return AppWindowClass.medium;
    return AppWindowClass.expanded;
  }
}
