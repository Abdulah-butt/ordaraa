import 'package:equatable/equatable.dart';

import '../../core/enums/address_type.dart';

class Address extends Equatable {
  const Address({
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

  Address copyWith({
    String? id,
    AddressType? type,
    String? Function()? label,
    String? Function()? contactName,
    String? Function()? contactPhone,
    String? line1,
    String? Function()? line2,
    String? city,
    String? Function()? state,
    String? Function()? postalCode,
    String? countryCode,
    String? Function()? latitude,
    String? Function()? longitude,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label == null ? this.label : label(),
      contactName: contactName == null ? this.contactName : contactName(),
      contactPhone: contactPhone == null ? this.contactPhone : contactPhone(),
      line1: line1 ?? this.line1,
      line2: line2 == null ? this.line2 : line2(),
      city: city ?? this.city,
      state: state == null ? this.state : state(),
      postalCode: postalCode == null ? this.postalCode : postalCode(),
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude == null ? this.latitude : latitude(),
      longitude: longitude == null ? this.longitude : longitude(),
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    label,
    contactName,
    contactPhone,
    line1,
    line2,
    city,
    state,
    postalCode,
    countryCode,
    latitude,
    longitude,
    isDefault,
    createdAt,
    updatedAt,
  ];
}
