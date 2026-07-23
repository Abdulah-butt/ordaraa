import 'package:equatable/equatable.dart';

import '../../../../domain/entities/organization.dart';
import '../../../../domain/entities/product.dart';

enum BuyerSearchResultType { products, suppliers }

class BuyerSearchState extends Equatable {
  const BuyerSearchState({
    required this.resultType,
    required this.products,
    required this.suppliers,
    required this.selectedCategory,
    required this.inStockOnly,
    required this.loadingResults,
    required this.loadingMore,
    required this.productHasNextPage,
    required this.productLoadedItemCount,
    required this.productTotalCount,
    required this.productTotalPages,
    required this.productSignature,
    required this.supplierHasNextPage,
    required this.supplierLoadedItemCount,
    required this.supplierTotalCount,
    required this.supplierTotalPages,
    required this.supplierSignature,
  });

  final BuyerSearchResultType resultType;
  final List<Product> products;
  final List<Organization> suppliers;
  final String selectedCategory;
  final bool inStockOnly;
  final bool loadingResults;
  final bool loadingMore;
  final bool productHasNextPage;
  final int productLoadedItemCount;
  final int productTotalCount;
  final int productTotalPages;
  final String productSignature;
  final bool supplierHasNextPage;
  final int supplierLoadedItemCount;
  final int supplierTotalCount;
  final int supplierTotalPages;
  final String supplierSignature;

  bool get hasNextPage => resultType == BuyerSearchResultType.products
      ? productHasNextPage
      : supplierHasNextPage;

  int get loadedItemCount => resultType == BuyerSearchResultType.products
      ? productLoadedItemCount
      : supplierLoadedItemCount;

  int get totalCount => resultType == BuyerSearchResultType.products
      ? productTotalCount
      : supplierTotalCount;

  int get totalPages => resultType == BuyerSearchResultType.products
      ? productTotalPages
      : supplierTotalPages;

  factory BuyerSearchState.initial() => const BuyerSearchState(
    resultType: BuyerSearchResultType.products,
    products: [],
    suppliers: [],
    selectedCategory: 'all-products',
    inStockOnly: false,
    loadingResults: false,
    loadingMore: false,
    productHasNextPage: false,
    productLoadedItemCount: 0,
    productTotalCount: 0,
    productTotalPages: 0,
    productSignature: '',
    supplierHasNextPage: false,
    supplierLoadedItemCount: 0,
    supplierTotalCount: 0,
    supplierTotalPages: 0,
    supplierSignature: '',
  );

  BuyerSearchState copyWith({
    BuyerSearchResultType? resultType,
    List<Product>? products,
    List<Organization>? suppliers,
    String? selectedCategory,
    bool? inStockOnly,
    bool? loadingResults,
    bool? loadingMore,
    bool? productHasNextPage,
    int? productLoadedItemCount,
    int? productTotalCount,
    int? productTotalPages,
    String? productSignature,
    bool? supplierHasNextPage,
    int? supplierLoadedItemCount,
    int? supplierTotalCount,
    int? supplierTotalPages,
    String? supplierSignature,
  }) => BuyerSearchState(
    resultType: resultType ?? this.resultType,
    products: products ?? this.products,
    suppliers: suppliers ?? this.suppliers,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    inStockOnly: inStockOnly ?? this.inStockOnly,
    loadingResults: loadingResults ?? this.loadingResults,
    loadingMore: loadingMore ?? this.loadingMore,
    productHasNextPage: productHasNextPage ?? this.productHasNextPage,
    productLoadedItemCount:
        productLoadedItemCount ?? this.productLoadedItemCount,
    productTotalCount: productTotalCount ?? this.productTotalCount,
    productTotalPages: productTotalPages ?? this.productTotalPages,
    productSignature: productSignature ?? this.productSignature,
    supplierHasNextPage: supplierHasNextPage ?? this.supplierHasNextPage,
    supplierLoadedItemCount:
        supplierLoadedItemCount ?? this.supplierLoadedItemCount,
    supplierTotalCount: supplierTotalCount ?? this.supplierTotalCount,
    supplierTotalPages: supplierTotalPages ?? this.supplierTotalPages,
    supplierSignature: supplierSignature ?? this.supplierSignature,
  );

  @override
  List<Object?> get props => [
    resultType,
    products,
    suppliers,
    selectedCategory,
    inStockOnly,
    loadingResults,
    loadingMore,
    productHasNextPage,
    productLoadedItemCount,
    productTotalCount,
    productTotalPages,
    productSignature,
    supplierHasNextPage,
    supplierLoadedItemCount,
    supplierTotalCount,
    supplierTotalPages,
    supplierSignature,
  ];
}
