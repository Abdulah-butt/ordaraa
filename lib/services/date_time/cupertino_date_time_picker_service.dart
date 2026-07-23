import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'date_time_picker_service.dart';

class CupertinoDateTimePickerService implements DateTimePickerService {
  @override
  Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime? selectedDate = initialDate ?? DateTime.now();

    final pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => _buildDatePicker(
        context,
        selectedDate,
        firstDate ?? DateTime(2000),
        lastDate ?? DateTime(2100),
      ),
    );

    return pickedDate ?? selectedDate;
  }

  Widget _buildDatePicker(
    BuildContext context,
    DateTime selectedDate,
    DateTime firstDate,
    DateTime lastDate, {
    CupertinoDatePickerMode? mode,
  }) {
    DateTime tempSelectedDate = selectedDate;
    return Container(
      height: 300,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.pop(context, tempSelectedDate),
              ),
            ],
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: mode ?? CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              minimumDate: firstDate,
              maximumDate: lastDate,
              onDateTimeChanged: (date) => tempSelectedDate = date,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<TimeOfDay?> pickTime({
    required BuildContext context,
    required TimeOfDay initialTime,
    bool is24HourFormat = false,
  }) async {
    DateTime initialDateTime = DateTime.now().copyWith(
      hour: initialTime.hour,
      minute: initialTime.minute,
    );

    final pickedDateTime = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) =>
          _buildTimePicker(context, initialDateTime, is24HourFormat),
    );

    return pickedDateTime != null
        ? TimeOfDay.fromDateTime(pickedDateTime)
        : TimeOfDay.fromDateTime(initialDateTime);
  }

  Widget _buildTimePicker(
    BuildContext context,
    DateTime selectedTime,
    bool is24HourFormat,
  ) {
    DateTime tempSelectedTime = selectedTime;

    return Container(
      height: 300,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.pop(context, tempSelectedTime),
              ),
            ],
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: selectedTime,
              use24hFormat: is24HourFormat,
              onDateTimeChanged: (time) => tempSelectedTime = time,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<DateTime?> pickDateTime({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    bool is24HourFormat = false,
  }) async {
    DateTime? selectedDate = initialDate ?? DateTime.now();

    final pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => _buildDatePicker(
        context,
        selectedDate,
        firstDate ?? DateTime(2000),
        lastDate ?? DateTime(2100),
        mode: CupertinoDatePickerMode.dateAndTime,
      ),
    );

    return pickedDate ?? selectedDate;
  }
}
