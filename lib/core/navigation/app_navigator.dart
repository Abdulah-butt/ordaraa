import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  Future<T?> push<T extends Object?>(BuildContext context, String path) {
    return context.push<T>(path);
  }

  void replace(BuildContext context, String path) {
    context.replace(path);
  }

  void pushAndClearAllPrevious(BuildContext context, String path) {
    while (context.canPop() == true) {
      context.pop();
    }
    context.pushReplacement(path);
  }

  Future<T?> showBottomSheet<T>(
    BuildContext context,
    Widget page, {
    bool fullSheet = false,
    double? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: !fullSheet,
      isDismissible: !fullSheet,
      showDragHandle: !fullSheet,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: fullSheet
          ? null
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
      constraints: fullSheet
          ? BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              minHeight: MediaQuery.of(context).size.height,
            )
          : null,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(
            context,
          ).viewInsets.bottom, // This accounts for keyboard
          left: padding ?? 16,
          right: padding ?? 16,
          top: 20,
        ),
        child: IntrinsicHeight(child: SafeArea(child: page)),
      ),
    );
  }

  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  Future<T?> showDialogBox<T>(BuildContext context, Widget page) {
    return showDialog<T>(
      context: context,
      useSafeArea: false,
      builder: (ctx) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(color: Colors.black.withValues(alpha: 0.1)),
              ),
              page,
            ],
          ),
        );
      },
    );
  }
}
