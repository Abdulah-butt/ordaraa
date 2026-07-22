import '../../../../core/navigation/route_params.dart';

class SellerRegistrationInitialParams extends RouteParams {
  const SellerRegistrationInitialParams({required this.phoneNumber});

  final String phoneNumber;

  @override
  Map<String, dynamic> toMap() => {'phoneNumber': phoneNumber};

  static SellerRegistrationInitialParams fromMap(Map<String, dynamic> map) {
    return SellerRegistrationInitialParams(
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
