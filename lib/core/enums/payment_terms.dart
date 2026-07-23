enum PaymentTerms {
  dueOnReceipt('DUE_ON_RECEIPT'),
  net7('NET_7'),
  net14('NET_14'),
  net30('NET_30');

  const PaymentTerms(this.apiValue);

  final String apiValue;

  String get displayText => switch (this) {
    PaymentTerms.dueOnReceipt => 'Due on receipt',
    PaymentTerms.net7 => 'Net 7 days',
    PaymentTerms.net14 => 'Net 14 days',
    PaymentTerms.net30 => 'Net 30 days',
  };

  static PaymentTerms fromApiValue(String value) {
    return PaymentTerms.values.firstWhere(
      (terms) => terms.apiValue == value,
      orElse: () => throw FormatException('Unknown payment terms: $value'),
    );
  }
}
