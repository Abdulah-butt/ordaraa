import 'package:equatable/equatable.dart';

import '../../../view_data/buyer_catalog_view_data.dart';

class BuyerHomeState extends Equatable {
  const BuyerHomeState({
    required this.deliveryLocation,
    required this.reorderDescription,
    required this.loadingCategories,
    required this.products,
    required this.suppliers,
  });

  final String deliveryLocation;
  final String reorderDescription;
  final bool loadingCategories;
  final List<BuyerProductViewData> products;
  final List<BuyerSupplierViewData> suppliers;

  factory BuyerHomeState.initial() => const BuyerHomeState(
    deliveryLocation: '',
    reorderDescription: '',
    loadingCategories: false,
    products: [],
    suppliers: [],
  );

  BuyerHomeState copyWith({
    String? deliveryLocation,
    String? reorderDescription,
    bool? loadingCategories,
    List<BuyerProductViewData>? products,
    List<BuyerSupplierViewData>? suppliers,
  }) {
    return BuyerHomeState(
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      reorderDescription: reorderDescription ?? this.reorderDescription,
      loadingCategories: loadingCategories ?? this.loadingCategories,
      products: products ?? this.products,
      suppliers: suppliers ?? this.suppliers,
    );
  }

  @override
  List<Object?> get props => [
    deliveryLocation,
    reorderDescription,
    loadingCategories,
    products,
    suppliers,
  ];
}
