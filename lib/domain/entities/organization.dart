import 'package:equatable/equatable.dart';

import '../../core/enums/organization_status.dart';
import '../../core/enums/organization_type.dart';
import '../../core/enums/payment_terms.dart';
import 'image_resource.dart';
import 'market.dart';
import 'address.dart';

class Organization extends Equatable {
  Organization({
    required this.id,
    required this.publicCode,
    required this.name,
    required this.type,
    required this.logo,
    required this.market,
    required this.status,
    required this.verified,
    required this.legalName,
    required this.registrationNumber,
    required this.taxNumber,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
    required this.defaultPaymentTerms,
    required this.createdAt,
    List<Address> addresses = const [],
  }) : addresses = List.unmodifiable(addresses);

  final String id;
  final String publicCode;
  final String name;
  final OrganizationType type;
  final ImageResource? logo;
  final Market market;
  final OrganizationStatus status;
  final bool verified;
  final String? legalName;
  final String? registrationNumber;
  final String? taxNumber;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final PaymentTerms? defaultPaymentTerms;
  final DateTime createdAt;
  final List<Address> addresses;

  Organization copyWith({
    String? id,
    String? publicCode,
    String? name,
    OrganizationType? type,
    ImageResource? Function()? logo,
    Market? market,
    OrganizationStatus? status,
    bool? verified,
    String? Function()? legalName,
    String? Function()? registrationNumber,
    String? Function()? taxNumber,
    String? Function()? contactName,
    String? Function()? contactEmail,
    String? Function()? contactPhone,
    PaymentTerms? Function()? defaultPaymentTerms,
    DateTime? createdAt,
    List<Address>? addresses,
  }) {
    return Organization(
      id: id ?? this.id,
      publicCode: publicCode ?? this.publicCode,
      name: name ?? this.name,
      type: type ?? this.type,
      logo: logo == null ? this.logo : logo(),
      market: market ?? this.market,
      status: status ?? this.status,
      verified: verified ?? this.verified,
      legalName: legalName == null ? this.legalName : legalName(),
      registrationNumber: registrationNumber == null
          ? this.registrationNumber
          : registrationNumber(),
      taxNumber: taxNumber == null ? this.taxNumber : taxNumber(),
      contactName: contactName == null ? this.contactName : contactName(),
      contactEmail: contactEmail == null ? this.contactEmail : contactEmail(),
      contactPhone: contactPhone == null ? this.contactPhone : contactPhone(),
      defaultPaymentTerms: defaultPaymentTerms == null
          ? this.defaultPaymentTerms
          : defaultPaymentTerms(),
      createdAt: createdAt ?? this.createdAt,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  List<Object?> get props => [
    id,
    publicCode,
    name,
    type,
    logo,
    market,
    status,
    verified,
    legalName,
    registrationNumber,
    taxNumber,
    contactName,
    contactEmail,
    contactPhone,
    defaultPaymentTerms,
    createdAt,
    addresses,
  ];
}
