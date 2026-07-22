enum MembershipRole {
  owner('OWNER'),
  admin('ADMIN'),
  member('MEMBER'),
  viewer('VIEWER');

  const MembershipRole(this.apiValue);

  final String apiValue;

  static MembershipRole fromApiValue(String value) {
    return MembershipRole.values.firstWhere(
      (role) => role.apiValue == value,
      orElse: () => throw FormatException('Unknown membership role: $value'),
    );
  }
}
