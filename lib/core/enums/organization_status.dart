enum OrganizationStatus {
  pending('PENDING'),
  active('ACTIVE'),
  suspended('SUSPENDED'),
  blocked('BLOCKED');

  const OrganizationStatus(this.apiValue);

  final String apiValue;

  static OrganizationStatus fromApiValue(String value) {
    return OrganizationStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () =>
          throw FormatException('Unknown organization status: $value'),
    );
  }
}
