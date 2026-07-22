import '../../core/enums/organization_status.dart';
import '../../core/enums/organization_type.dart';
import '../../core/enums/payment_terms.dart';
import '../../domain/entities/organization.dart';
import 'image_resource_json.dart';
import 'market_json.dart';

class OrganizationJson {
  const OrganizationJson({
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
  });

  final String id;
  final String publicCode;
  final String name;
  final OrganizationType type;
  final ImageResourceJson? logo;
  final MarketJson market;
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

  factory OrganizationJson.fromJson(Map<String, dynamic> json) {
    final logoJson = json['logo'];
    final paymentTermsValue = json['defaultPaymentTerms'] as String?;
    return OrganizationJson(
      id: json['id'] as String,
      publicCode: json['publicCode'] as String,
      name: json['name'] as String,
      type: OrganizationType.fromApiValue(json['type'] as String),
      logo: logoJson is Map<String, dynamic>
          ? ImageResourceJson.fromJson(logoJson)
          : null,
      market: MarketJson.fromJson(json['market'] as Map<String, dynamic>),
      status: OrganizationStatus.fromApiValue(json['status'] as String),
      verified: json['verified'] as bool,
      legalName: json['legalName'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      taxNumber: json['taxNumber'] as String?,
      contactName: json['contactName'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      defaultPaymentTerms: paymentTermsValue == null
          ? null
          : PaymentTerms.fromApiValue(paymentTermsValue),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'publicCode': publicCode,
    'name': name,
    'type': type.apiValue,
    'logo': logo?.toJson(),
    'market': market.toJson(),
    'status': status.apiValue,
    'verified': verified,
    'legalName': legalName,
    'registrationNumber': registrationNumber,
    'taxNumber': taxNumber,
    'contactName': contactName,
    'contactEmail': contactEmail,
    'contactPhone': contactPhone,
    'defaultPaymentTerms': defaultPaymentTerms?.apiValue,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };

  Organization toDomain() => Organization(
    id: id,
    publicCode: publicCode,
    name: name,
    type: type,
    logo: logo?.toDomain(),
    market: market.toDomain(),
    status: status,
    verified: verified,
    legalName: legalName,
    registrationNumber: registrationNumber,
    taxNumber: taxNumber,
    contactName: contactName,
    contactEmail: contactEmail,
    contactPhone: contactPhone,
    defaultPaymentTerms: defaultPaymentTerms,
    createdAt: createdAt,
  );
}
