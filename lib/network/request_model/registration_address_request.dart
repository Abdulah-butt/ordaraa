import '../../core/enums/address_type.dart';

class RegistrationAddressRequest {
  const RegistrationAddressRequest({
    required this.type,
    required this.line1,
    required this.city,
    required this.countryCode,
    this.label,
    this.contactName,
    this.contactPhone,
    this.line2,
    this.state,
    this.postalCode,
  });

  final AddressType type;
  final String? label;
  final String? contactName;
  final String? contactPhone;
  final String line1;
  final String? line2;
  final String city;
  final String? state;
  final String? postalCode;
  final String countryCode;

  Map<String, dynamic> toJson() => {
    'type': type.apiValue,
    if (label != null) 'label': label,
    if (contactName != null) 'contactName': contactName,
    if (contactPhone != null) 'contactPhone': contactPhone,
    'line1': line1,
    if (line2 != null) 'line2': line2,
    'city': city,
    if (state != null) 'state': state,
    if (postalCode != null) 'postalCode': postalCode,
    'countryCode': countryCode,
  };
}
