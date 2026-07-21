int toInt(dynamic value) {
  if (value == null) return 0; // or throw an error

  if (value is int) {
    return value;
  } else if (value is double) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value) ??
        (double.tryParse(value)?.toInt() ?? 0); // Fallback for "123.45"
  } else {
    return 0; // or throw ArgumentError("Invalid number format");
  }
}


