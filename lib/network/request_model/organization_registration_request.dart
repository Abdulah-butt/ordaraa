import '../../core/enums/payment_terms.dart';
import 'registration_address_request.dart';

class OrganizationRegistrationRequest {
  const OrganizationRegistrationRequest({
    required this.name,
    required this.marketId,
    required this.address,
    this.legalName,
    this.registrationNumber,
    this.taxNumber,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.defaultPaymentTerms,
  });

  final String name;
  final String marketId;
  final RegistrationAddressRequest address;
  final String? legalName;
  final String? registrationNumber;
  final String? taxNumber;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final PaymentTerms? defaultPaymentTerms;

  Map<String, dynamic> toBuyerJson() => {
    'name': name,
    ..._sharedJson,
    if (defaultPaymentTerms != null)
      'defaultPaymentTerms': defaultPaymentTerms!.apiValue,
  };

  Map<String, dynamic> toSellerJson() => {
    'organizationName': name,
    ..._sharedJson,
  };

  Map<String, dynamic> get _sharedJson => {
    'marketId': marketId,
    if (legalName != null) 'legalName': legalName,
    if (registrationNumber != null) 'registrationNumber': registrationNumber,
    if (taxNumber != null) 'taxNumber': taxNumber,
    if (contactName != null) 'contactName': contactName,
    if (contactEmail != null) 'contactEmail': contactEmail,
    if (contactPhone != null) 'contactPhone': contactPhone,
    'address': address.toJson(),
  };
}
