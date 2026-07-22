enum AddressType {
  delivery('DELIVERY'),
  billing('BILLING'),
  warehouse('WAREHOUSE'),
  registered('REGISTERED'),
  other('OTHER');

  const AddressType(this.apiValue);

  final String apiValue;

  static AddressType fromApiValue(String value) {
    return AddressType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => throw FormatException('Unknown address type: $value'),
    );
  }
}
