enum OrganizationType {
  buyer('BUYER'),
  seller('SELLER'),
  both('BOTH'),
  admin('ADMIN');

  const OrganizationType(this.apiValue);

  final String apiValue;

  String get displayText => switch (this) {
    OrganizationType.buyer => 'Buyer',
    OrganizationType.seller => 'Seller',
    OrganizationType.both => 'Buyer and seller',
    OrganizationType.admin => 'Administrator',
  };

  static OrganizationType fromApiValue(String value) {
    return OrganizationType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => throw FormatException('Unknown organization type: $value'),
    );
  }
}
