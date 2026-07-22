enum CategoryStatus {
  active('ACTIVE'),
  inactive('INACTIVE');

  const CategoryStatus(this.apiValue);
  final String apiValue;

  static CategoryStatus fromApiValue(String value) {
    return CategoryStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown category status: $value'),
    );
  }
}
