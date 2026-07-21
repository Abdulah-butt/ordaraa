extension ToDoubleExtension on dynamic {
  double toDoubleOrZero() {
    if (this == null) return 0.0;
    if (this is double) return this as double;
    if (this is int) return (this as int).toDouble();
    if (this is String) {
      final s = (this as String).trim().replaceAll('"', '');
      return double.tryParse(s) ?? 0.0;
    }

    return 0.0;
  }
}
