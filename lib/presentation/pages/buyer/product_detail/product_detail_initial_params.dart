import '../../../../core/navigation/route_params.dart';

class ProductDetailInitialParams extends RouteParams {
  const ProductDetailInitialParams({required this.productId});

  final String productId;

  @override
  Map<String, dynamic> toMap() => {'productId': productId};

  static ProductDetailInitialParams fromMap(Map<String, dynamic> map) {
    return ProductDetailInitialParams(
      productId: map['productId'] as String? ?? '',
    );
  }
}
