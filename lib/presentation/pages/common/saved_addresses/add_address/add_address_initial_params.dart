import '../../../../../core/navigation/route_params.dart';
import '../../../../../core/enums/address_type.dart';
import '../../../../../domain/entities/address.dart';

class AddAddressInitialParams extends RouteParams {
  const AddAddressInitialParams({this.address});

  final Address? address;

  @override
  Map<String, dynamic> toMap() {
    final value = address;
    if (value == null) return const {};
    return {
      'id': value.id,
      'type': value.type.apiValue,
      'label': value.label ?? '',
      'contactName': value.contactName ?? '',
      'contactPhone': value.contactPhone ?? '',
      'line1': value.line1,
      'line2': value.line2 ?? '',
      'city': value.city,
      'state': value.state ?? '',
      'postalCode': value.postalCode ?? '',
      'countryCode': value.countryCode,
      'latitude': value.latitude ?? '',
      'longitude': value.longitude ?? '',
      'isDefault': value.isDefault.toString(),
      'createdAt': value.createdAt.toIso8601String(),
      'updatedAt': value.updatedAt.toIso8601String(),
    };
  }

  static AddAddressInitialParams fromMap(Map<String, dynamic> map) {
    final id = map['id'] as String?;
    if (id == null || id.isEmpty) return const AddAddressInitialParams();
    return AddAddressInitialParams(
      address: Address(
        id: id,
        type: AddressType.fromApiValue(map['type'] as String),
        label: _nullable(map['label']),
        contactName: _nullable(map['contactName']),
        contactPhone: _nullable(map['contactPhone']),
        line1: map['line1'] as String? ?? '',
        line2: _nullable(map['line2']),
        city: map['city'] as String? ?? '',
        state: _nullable(map['state']),
        postalCode: _nullable(map['postalCode']),
        countryCode: map['countryCode'] as String? ?? '',
        latitude: _nullable(map['latitude']),
        longitude: _nullable(map['longitude']),
        isDefault: map['isDefault'] == 'true',
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      ),
    );
  }

  static String? _nullable(dynamic value) {
    final text = value as String?;
    return text == null || text.isEmpty ? null : text;
  }
}
