enum UnitKind {
  weight('WEIGHT'),
  count('COUNT'),
  pack('PACK'),
  volume('VOLUME'),
  other('OTHER');

  const UnitKind(this.apiValue);

  final String apiValue;

  static UnitKind fromApiValue(String value) {
    return UnitKind.values.firstWhere(
      (kind) => kind.apiValue == value,
      orElse: () => throw FormatException('Unknown unit kind: $value'),
    );
  }
}
