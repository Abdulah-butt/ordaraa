import 'package:equatable/equatable.dart';

import '../../../../domain/entities/organization.dart';
import '../../../../domain/entities/product.dart';

class BuyerHomeState extends Equatable {
  const BuyerHomeState({
    required this.deliveryLocation,
    required this.loadingProducts,
    required this.loadingSuppliers,
    required this.products,
    required this.suppliers,
  });

  final String deliveryLocation;
  final bool loadingProducts;
  final bool loadingSuppliers;
  final List<Product> products;
  final List<Organization> suppliers;

  factory BuyerHomeState.initial() => const BuyerHomeState(
    deliveryLocation: '',
    loadingProducts: false,
    loadingSuppliers: false,
    products: [],
    suppliers: [],
  );

  BuyerHomeState copyWith({
    String? deliveryLocation,
    bool? loadingProducts,
    bool? loadingSuppliers,
    List<Product>? products,
    List<Organization>? suppliers,
  }) {
    return BuyerHomeState(
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      loadingProducts: loadingProducts ?? this.loadingProducts,
      loadingSuppliers: loadingSuppliers ?? this.loadingSuppliers,
      products: products ?? this.products,
      suppliers: suppliers ?? this.suppliers,
    );
  }

  @override
  List<Object?> get props => [
    deliveryLocation,
    loadingProducts,
    loadingSuppliers,
    products,
    suppliers,
  ];
}
