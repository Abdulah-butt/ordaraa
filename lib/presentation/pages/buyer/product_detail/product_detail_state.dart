import 'package:equatable/equatable.dart';

import '../../../../domain/entities/product.dart';

class ProductDetailState extends Equatable {
  const ProductDetailState({
    required this.product,
    required this.loading,
    required this.errorMessage,
    required this.quantity,
  });

  final Product? product;
  final bool loading;
  final String? errorMessage;
  final int quantity;

  factory ProductDetailState.initial() => const ProductDetailState(
    product: null,
    loading: false,
    errorMessage: null,
    quantity: 1,
  );

  ProductDetailState copyWith({
    Product? Function()? product,
    bool? loading,
    String? Function()? errorMessage,
    int? quantity,
  }) {
    return ProductDetailState(
      product: product == null ? this.product : product(),
      loading: loading ?? this.loading,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, loading, errorMessage, quantity];
}
