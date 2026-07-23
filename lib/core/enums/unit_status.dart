enum UnitStatus {
  active('ACTIVE'),
  inactive('INACTIVE');

  const UnitStatus(this.apiValue);

  final String apiValue;

  static UnitStatus fromApiValue(String value) {
    return UnitStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown unit status: $value'),
    );
  }
}
