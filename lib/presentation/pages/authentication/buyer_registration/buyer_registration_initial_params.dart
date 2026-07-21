import '../../../../core/navigation/route_params.dart';

class BuyerRegistrationInitialParams extends RouteParams {
  const BuyerRegistrationInitialParams({required this.phoneNumber});

  final String phoneNumber;

  @override
  Map<String, dynamic> toMap() => {'phoneNumber': phoneNumber};

  static BuyerRegistrationInitialParams fromMap(Map<String, dynamic> map) {
    return BuyerRegistrationInitialParams(
      phoneNumber: map['phoneNumber'] ?? '+61 412 345 678',
    );
  }
}
