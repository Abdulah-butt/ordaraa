import '../../../../core/navigation/route_params.dart';

class OrderDetailInitialParams extends RouteParams {
  const OrderDetailInitialParams({required this.orderId});

  final String orderId;

  @override
  Map<String, dynamic> toMap() => {'orderId': orderId};

  static OrderDetailInitialParams fromMap(Map<String, dynamic> map) {
    return OrderDetailInitialParams(orderId: map['orderId'] as String? ?? '');
  }
}
