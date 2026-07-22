enum MembershipStatus {
  invited('INVITED'),
  active('ACTIVE'),
  suspended('SUSPENDED'),
  removed('REMOVED');

  const MembershipStatus(this.apiValue);

  final String apiValue;

  static MembershipStatus fromApiValue(String value) {
    return MembershipStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown membership status: $value'),
    );
  }
}
