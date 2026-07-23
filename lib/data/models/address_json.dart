import '../../core/enums/address_type.dart';
import '../../domain/entities/address.dart';

class AddressJson {
  const AddressJson({
    required this.id,
    required this.type,
    required this.label,
    required this.contactName,
    required this.contactPhone,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
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
  final String? latitude;
  final String? longitude;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory AddressJson.fromJson(Map<String, dynamic> json) {
    return AddressJson(
      id: json['id'] as String,
      type: AddressType.fromApiValue(json['type'] as String),
      label: json['label'] as String?,
      contactName: json['contactName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      countryCode: json['countryCode'] as String,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.apiValue,
    'label': label,
    'contactName': contactName,
    'contactPhone': contactPhone,
    'line1': line1,
    'line2': line2,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'countryCode': countryCode,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  Address toDomain() => Address(
    id: id,
    type: type,
    label: label,
    contactName: contactName,
    contactPhone: contactPhone,
    line1: line1,
    line2: line2,
    city: city,
    state: state,
    postalCode: postalCode,
    countryCode: countryCode,
    latitude: latitude,
    longitude: longitude,
    isDefault: isDefault,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
