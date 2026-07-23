import '../enums/payment_terms.dart';

extension PaymentTermsLabel on PaymentTerms {
  String get label => switch (this) {
    PaymentTerms.dueOnReceipt => 'Due on receipt',
    PaymentTerms.net7 => 'Net 7',
    PaymentTerms.net14 => 'Net 14',
    PaymentTerms.net30 => 'Net 30',
  };
}
