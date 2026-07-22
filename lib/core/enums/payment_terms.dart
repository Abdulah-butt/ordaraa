enum PaymentTerms {
  dueOnReceipt('DUE_ON_RECEIPT'),
  net7('NET_7'),
  net14('NET_14'),
  net30('NET_30');

  const PaymentTerms(this.apiValue);

  final String apiValue;

  static PaymentTerms fromApiValue(String value) {
    return PaymentTerms.values.firstWhere(
      (terms) => terms.apiValue == value,
      orElse: () => throw FormatException('Unknown payment terms: $value'),
    );
  }
}
