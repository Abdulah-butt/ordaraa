import '../../../../core/navigation/route_params.dart';

class SellerDetailInitialParams extends RouteParams {
  const SellerDetailInitialParams({required this.sellerId});

  final String sellerId;

  @override
  Map<String, dynamic> toMap() => {'sellerId': sellerId};

  static SellerDetailInitialParams fromMap(Map<String, dynamic> map) {
    return SellerDetailInitialParams(
      sellerId: map['sellerId'] as String? ?? '',
    );
  }
}
