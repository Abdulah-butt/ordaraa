import 'package:flutter/material.dart';

class RoutingAnimation<T> extends PageRouteBuilder<T> {
  final Widget child;

  RoutingAnimation({required this.child})
      : super(
    transitionDuration: const Duration(milliseconds: 500), // Increase the duration of the animation
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return child;
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return FadeTransition(
        opacity: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut, // Use a slower curve for smoother animation
        )),
        child: child,
      );
    },
  );
}
