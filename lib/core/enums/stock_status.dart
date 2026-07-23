enum StockStatus {
  inStock('IN_STOCK'),
  lowStock('LOW_STOCK'),
  outOfStock('OUT_OF_STOCK'),
  unavailable('UNAVAILABLE');

  const StockStatus(this.apiValue);

  final String apiValue;

  static StockStatus fromApiValue(String value) {
    return StockStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown stock status: $value'),
    );
  }
}
