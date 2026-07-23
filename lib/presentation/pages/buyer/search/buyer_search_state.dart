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
    required this.productNextCursor,
    required this.productTotalCount,
    required this.productSignature,
    required this.supplierHasNextPage,
    required this.supplierNextCursor,
    required this.supplierTotalCount,
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
  final String? productNextCursor;
  final int productTotalCount;
  final String productSignature;
  final bool supplierHasNextPage;
  final String? supplierNextCursor;
  final int supplierTotalCount;
  final String supplierSignature;

  bool get hasNextPage => resultType == BuyerSearchResultType.products
      ? productHasNextPage
      : supplierHasNextPage;

  String? get nextCursor => resultType == BuyerSearchResultType.products
      ? productNextCursor
      : supplierNextCursor;

  int get visibleResultCount => resultType == BuyerSearchResultType.products
      ? products.length
      : suppliers.length;

  int get totalCount => resultType == BuyerSearchResultType.products
      ? productTotalCount
      : supplierTotalCount;

  factory BuyerSearchState.initial() => const BuyerSearchState(
    resultType: BuyerSearchResultType.products,
    products: [],
    suppliers: [],
    selectedCategory: 'all-products',
    inStockOnly: false,
    loadingResults: false,
    loadingMore: false,
    productHasNextPage: false,
    productNextCursor: null,
    productTotalCount: 0,
    productSignature: '',
    supplierHasNextPage: false,
    supplierNextCursor: null,
    supplierTotalCount: 0,
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
    String? Function()? productNextCursor,
    int? productTotalCount,
    String? productSignature,
    bool? supplierHasNextPage,
    String? Function()? supplierNextCursor,
    int? supplierTotalCount,
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
    productNextCursor: productNextCursor == null
        ? this.productNextCursor
        : productNextCursor(),
    productTotalCount: productTotalCount ?? this.productTotalCount,
    productSignature: productSignature ?? this.productSignature,
    supplierHasNextPage: supplierHasNextPage ?? this.supplierHasNextPage,
    supplierNextCursor: supplierNextCursor == null
        ? this.supplierNextCursor
        : supplierNextCursor(),
    supplierTotalCount: supplierTotalCount ?? this.supplierTotalCount,
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
    productNextCursor,
    productTotalCount,
    productSignature,
    supplierHasNextPage,
    supplierNextCursor,
    supplierTotalCount,
    supplierSignature,
  ];
}
