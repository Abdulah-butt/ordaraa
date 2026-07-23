import 'package:equatable/equatable.dart';

import '../../../../domain/entities/organization.dart';
import '../../../../domain/entities/product.dart';

class SellerDetailState extends Equatable {
  const SellerDetailState({
    required this.detail,
    required this.products,
    required this.loading,
    required this.loadingMore,
    required this.hasNextPage,
    required this.nextCursor,
    required this.totalCount,
    required this.errorMessage,
  });

  final Organization? detail;
  final List<Product> products;
  final bool loading;
  final bool loadingMore;
  final bool hasNextPage;
  final String? nextCursor;
  final int totalCount;
  final String? errorMessage;

  factory SellerDetailState.initial() => const SellerDetailState(
    detail: null,
    products: [],
    loading: false,
    loadingMore: false,
    hasNextPage: false,
    nextCursor: null,
    totalCount: 0,
    errorMessage: null,
  );

  SellerDetailState copyWith({
    Organization? Function()? detail,
    List<Product>? products,
    bool? loading,
    bool? loadingMore,
    bool? hasNextPage,
    String? Function()? nextCursor,
    int? totalCount,
    String? Function()? errorMessage,
  }) {
    return SellerDetailState(
      detail: detail == null ? this.detail : detail(),
      products: products ?? this.products,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      nextCursor: nextCursor == null ? this.nextCursor : nextCursor(),
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }

  @override
  List<Object?> get props => [
    detail,
    products,
    loading,
    loadingMore,
    hasNextPage,
    nextCursor,
    totalCount,
    errorMessage,
  ];
}
