enum PlatformRole {
  platformAdmin('PLATFORM_ADMIN'),
  platformSupport('PLATFORM_SUPPORT');

  const PlatformRole(this.apiValue);

  final String apiValue;

  static PlatformRole fromApiValue(String value) {
    return PlatformRole.values.firstWhere(
      (role) => role.apiValue == value,
      orElse: () => throw FormatException('Unknown platform role: $value'),
    );
  }
}
