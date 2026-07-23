import 'package:flutter/material.dart';
import 'number_extension.dart';

extension StringExtension on String {
  bool isValidEmail() {
    // Regular expression for validating email addresses
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
      caseSensitive: false,
      multiLine: false,
    );

    // Check if the email is not empty and matches the regex
    return isNotEmpty && emailRegExp.hasMatch(this);
  }

  bool get isValidUrl {
    final uri = Uri.tryParse(this);
    return uri != null && uri.hasAbsolutePath;
  }

  String capitalizeFirstWord() {
    if (isEmpty) return this;

    List<String> words = split(' '); // Split by spaces
    if (words.isEmpty) return this;

    words[0] = words[0][0].toUpperCase() + words[0].substring(1);

    return words.join(' '); // Rejoin words
  }

  String capitalizeFirstLetters() {
    if (isEmpty) {
      return this;
    }
    final words = split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      } else {
        return word;
      }
    }).toList();
    return capitalizedWords.join(' ');
  }

  void validatePassword() {
    if (isEmpty) {
      throw "Password cannot be empty.";
    }

    // Check if the password is at least 8 characters long
    if (length < 8) {
      throw "Password must be at least 8 characters long.";
    }

    // Check if the password contains at least one uppercase letter
    if (!contains(RegExp(r'[A-Z]'))) {
      throw "Password must contain at least one uppercase letter.";
    }

    // Check if the password contains at least one number
    if (!contains(RegExp(r'[0-9]'))) {
      throw "Password must contain at least one number.";
    }

    // If all conditions are met, the password is valid
  }

  void validateDob() {
    // Regular expression to match the YYYY-MM-dd format
    final RegExp dobRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');

    // Check if the string matches the format
    if (!dobRegExp.hasMatch(this)) {
      throw "Invalid date format. Expected format: YYYY-MM-dd.";
    }

    // Try to parse the date
    DateTime date;
    try {
      date = DateTime.parse(this);
    } catch (e) {
      throw "Invalid date. Please provide a valid date.";
    }

    // Check if the date is in the future
    if (date.isAfter(DateTime.now())) {
      throw "Date of birth cannot be in the future.";
    }

    // Validate the month
    final int month = date.month;
    if (month < 1 || month > 12) {
      throw "Invalid month. Month must be between 01 and 12.";
    }

    // Validate the day
    final int day = date.day;
    if (day < 1 || day > 31) {
      throw "Invalid day. Day must be between 01 and 31.";
    }

    // Validate specific month-day combinations (e.g., February 30)
    final int year = date.year;
    final int daysInMonth = DateTime(
      year,
      month + 1,
      0,
    ).day; // Get the last day of the month
    if (day > daysInMonth) {
      throw "Invalid day. Month $month only has $daysInMonth days.";
    }

    // Ensure the parsed date matches the input string
    final String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    if (formattedDate != this) {
      throw "Invalid date. Please provide a valid date.";
    }
  }

  String get maskPhoneNumber {
    final last4 = substring(length - 4);
    return '****$last4';
  }
}
