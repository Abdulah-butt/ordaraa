import '../../core/enums/payment_terms.dart';

class UpdateOrganizationProfileRequest {
  const UpdateOrganizationProfileRequest({
    required this.name,
    required this.legalName,
    required this.registrationNumber,
    required this.taxNumber,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.defaultPaymentTerms,
  });

  final String name;
  final String? legalName;
  final String? registrationNumber;
  final String? taxNumber;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final PaymentTerms? defaultPaymentTerms;

  Map<String, dynamic> toJson() => {
    'name': name,
    'legalName': legalName,
    'registrationNumber': registrationNumber,
    'taxNumber': taxNumber,
    'contactName': contactName,
    'contactEmail': contactEmail,
    'contactPhone': contactPhone,
    'defaultPaymentTerms': defaultPaymentTerms?.apiValue,
  };
}
