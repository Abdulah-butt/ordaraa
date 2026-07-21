// lib/core/services/date_time_picker_service.dart
import 'package:flutter/material.dart';

import 'cupertino_date_time_picker_service.dart';
import 'material_date_time_picker_service.dart';

abstract class DateTimePickerService {
  Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  });

  Future<TimeOfDay?> pickTime({
    required BuildContext context,
    required TimeOfDay initialTime,
    bool is24HourFormat = false,
  });

  Future<DateTime?> pickDateTime({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    bool is24HourFormat = false,
  });
}

// lib/core/factories/date_time_picker_factory.dart
class DateTimePickerFactory {
  static DateTimePickerService getPickerService(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        return CupertinoDateTimePickerService();
      default:
        return MaterialDateTimePickerService();
    }
  }
}