import '../../../../core/navigation/route_params.dart';

class OrderConfirmedInitialParams extends RouteParams {
  const OrderConfirmedInitialParams({required this.orderId});

  final String orderId;

  @override
  Map<String, dynamic> toMap() => {'orderId': orderId};

  static OrderConfirmedInitialParams fromMap(Map<String, dynamic> map) {
    return OrderConfirmedInitialParams(
      orderId: map['orderId'] as String? ?? '',
    );
  }
}
