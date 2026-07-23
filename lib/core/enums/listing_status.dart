enum ListingStatus {
  draft('DRAFT'),
  active('ACTIVE'),
  paused('PAUSED'),
  archived('ARCHIVED');

  const ListingStatus(this.apiValue);

  final String apiValue;

  static ListingStatus fromApiValue(String value) {
    return ListingStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown listing status: $value'),
    );
  }
}
