import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouteTransition {
  const AppRouteTransition._();

  static const duration = Duration(milliseconds: 220);
  static const reverseDuration = Duration(milliseconds: 180);

  static Page<void> build({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      arguments: state.extra,
      restorationId: state.pageKey.value,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
          return child;
        }

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.018),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
