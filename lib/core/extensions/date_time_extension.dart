extension DateTimeStringExtension on String {

  DateTime toDateTime() {
    try {
      final parts = split('/');
      if (parts.length != 3) throw FormatException("Invalid date format");

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      throw FormatException("Unable to parse date: $this");
    }
  }
}

