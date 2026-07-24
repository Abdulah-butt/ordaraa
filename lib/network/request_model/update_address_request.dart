import 'add_address_request.dart';

class UpdateAddressRequest extends AddAddressRequest {
  const UpdateAddressRequest({
    required super.type,
    required super.line1,
    required super.city,
    required super.countryCode,
    required super.isDefault,
    super.label,
    super.contactName,
    super.contactPhone,
    super.line2,
    super.state,
    super.postalCode,
  });

  factory UpdateAddressRequest.fromCreate(AddAddressRequest request) {
    return UpdateAddressRequest(
      type: request.type,
      label: request.label,
      contactName: request.contactName,
      contactPhone: request.contactPhone,
      line1: request.line1,
      line2: request.line2,
      city: request.city,
      state: request.state,
      postalCode: request.postalCode,
      countryCode: request.countryCode,
      isDefault: request.isDefault,
    );
  }
}
