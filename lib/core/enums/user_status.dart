enum UserStatus {
  active('ACTIVE'),
  blocked('BLOCKED'),
  deactivated('DEACTIVATED');

  const UserStatus(this.apiValue);

  final String apiValue;

  static UserStatus fromApiValue(String value) {
    return UserStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown user status: $value'),
    );
  }
}
