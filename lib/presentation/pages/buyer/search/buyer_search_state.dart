import 'package:equatable/equatable.dart';

import '../../../view_data/buyer_catalog_view_data.dart';

enum BuyerSearchResultType { products, suppliers }

class BuyerSearchState extends Equatable {
  const BuyerSearchState({
    required this.resultType,
    required this.resultCount,
    required this.products,
    required this.suppliers,
    required this.selectedCategory,
    required this.inStockOnly,
  });

  final BuyerSearchResultType resultType;
  final int resultCount;
  final List<BuyerProductViewData> products;
  final List<BuyerSupplierViewData> suppliers;
  final String selectedCategory;
  final bool inStockOnly;

  factory BuyerSearchState.initial() => const BuyerSearchState(
    resultType: BuyerSearchResultType.products,
    resultCount: 24,
    products: [],
    suppliers: [],
    selectedCategory: 'all-products',
    inStockOnly: true,
  );

  BuyerSearchState copyWith({
    BuyerSearchResultType? resultType,
    int? resultCount,
    List<BuyerProductViewData>? products,
    List<BuyerSupplierViewData>? suppliers,
    String? selectedCategory,
    bool? inStockOnly,
  }) => BuyerSearchState(
    resultType: resultType ?? this.resultType,
    resultCount: resultCount ?? this.resultCount,
    products: products ?? this.products,
    suppliers: suppliers ?? this.suppliers,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    inStockOnly: inStockOnly ?? this.inStockOnly,
  );

  @override
  List<Object?> get props => [
    resultType,
    resultCount,
    products,
    suppliers,
    selectedCategory,
    inStockOnly,
  ];
}
