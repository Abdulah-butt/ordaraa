import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import '../navigation/app_navigator.dart';

enum SnackBarType { ERROR, SUCCESS, INFO }

class AppSnackBar {
  BuildContext get context => AppNavigator.navigatorKey.currentContext!;

  /// Shows a Swift-style toast notification
  void show(
    String message, {
    SnackBarType snackBarType = SnackBarType.INFO,
    Duration duration = const Duration(seconds: 3),
    bool autoDismiss = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;

    IconData icon;

    switch (snackBarType) {
      case SnackBarType.SUCCESS:
        backgroundColor = Color(0xff34C759);
        foregroundColor = colorScheme.surface;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.ERROR:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.surface;
        icon = Icons.error_outline;
        break;
      case SnackBarType.INFO:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        icon = Icons.info_outline;
        break;
    }

    ElegantNotification(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 60,
      animation: AnimationType.fromTop,
      autoDismiss: autoDismiss,
      icon: Icon(icon, color: foregroundColor),
      background: backgroundColor,
      showProgressIndicator: false,
      displayCloseButton: false,
      borderRadius: BorderRadius.circular(50),
      shadow: BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 10,
        spreadRadius: 2,
      ),
      description: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ).show(context);
  }

  /// Quick success toast
  void success(String message, {Duration? duration}) {
    show(
      message,
      snackBarType: SnackBarType.SUCCESS,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// Quick error toast
  void error(String message, {Duration? duration}) {
    show(
      message,
      snackBarType: SnackBarType.ERROR,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Quick info toast
  void info(String message, {Duration? duration}) {
    show(
      message,
      snackBarType: SnackBarType.INFO,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
