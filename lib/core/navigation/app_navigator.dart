import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  push(
    BuildContext context,
    String path,
  ) {
    context.push(path);
  }

  replace(BuildContext context, String path) {
    context.replace(path);
  }

  pushAndClearAllPrevious(BuildContext context, String path) {
    while (context.canPop() == true) {
      context.pop();
    }
    context.pushReplacement(path);
  }

  showBottomSheet(
    BuildContext context,
    Widget page, {
    bool fullSheet = false,
    double? padding,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: !fullSheet,
      isDismissible: !fullSheet,
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

  pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  showDialogBox(BuildContext context, Widget page) {
    showDialog(
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
                child: Container(
                  color: Colors.black.withOpacity(0.1), // Add a slight tint
                ),
              ),
              page,
            ],
          ),
        );
      },
    );
  }
}
