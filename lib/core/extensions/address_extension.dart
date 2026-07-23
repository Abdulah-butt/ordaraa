import '../../domain/entities/address.dart';

extension AddressFormatting on Address {
  String get displayAddress {
    return [
      line1,
      if (line2 != null && line2!.trim().isNotEmpty) line2!,
      city,
      if (state != null && state!.trim().isNotEmpty) state!,
      if (postalCode != null && postalCode!.trim().isNotEmpty) postalCode!,
    ].join(', ');
  }

  String get shortAddress {
    return [
      city,
      if (state != null && state!.trim().isNotEmpty) state!,
      if (postalCode != null && postalCode!.trim().isNotEmpty) postalCode!,
    ].join(' ');
  }
}
