enum MarketStatus {
  active('ACTIVE'),
  inactive('INACTIVE');

  const MarketStatus(this.apiValue);

  final String apiValue;

  static MarketStatus fromApiValue(String value) {
    return MarketStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown market status: $value'),
    );
  }
}
