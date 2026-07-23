import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/extensions/add_to_cart_result_extension.dart';
import '../../../../core/enums/stock_status.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/organization.dart';
import '../../../../domain/entities/paginated_result.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/stores/category_store.dart';
import '../../../../domain/usecases/get_organizations_use_case.dart';
import '../../../../domain/usecases/get_product_listings_use_case.dart';
import '../../../../domain/usecases/add_to_cart_use_case.dart';
import '../../../../network/request_model/organization_listing_request.dart';
import '../../../../network/request_model/product_listing_request.dart';
import 'buyer_search_initial_params.dart';
import 'buyer_search_navigator.dart';
import 'buyer_search_state.dart';

class BuyerSearchCubit extends Cubit<BuyerSearchState> {
  BuyerSearchCubit({
    required this.navigator,
    required this.categoryStore,
    required this.getProductListingsUseCase,
    required this.getOrganizationsUseCase,
    required this.addToCartUseCase,
    required this.snackBar,
  }) : super(BuyerSearchState.initial());

  static const _limit = 10;
  static const _searchDebounce = Duration(milliseconds: 400);

  final BuyerSearchNavigator navigator;
  final CategoryStore categoryStore;
  final GetProductListingsUseCase getProductListingsUseCase;
  final GetOrganizationsUseCase getOrganizationsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final AppSnackBar snackBar;
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  Timer? _searchTimer;
  int _requestGeneration = 0;
  bool _initialized = false;

  List<Category> get categories => categoryStore.state.categories;

  Category? get selectedCategory => categories
      .where((category) => category.slug == state.selectedCategory)
      .firstOrNull;

  void onInit(BuyerSearchInitialParams initialParams) {
    _searchTimer?.cancel();
    scrollController
      ..removeListener(_onScroll)
      ..addListener(_onScroll);
    if (!_initialized) {
      _initialized = true;
      emit(
        state.copyWith(
          selectedCategory: initialParams.categorySlug ?? 'all-products',
          resultType: initialParams.showSuppliers
              ? BuyerSearchResultType.suppliers
              : BuyerSearchResultType.products,
        ),
      );
      unawaited(_initialize());
      return;
    }

    if (initialParams.categorySlug != null) {
      searchController.clear();
      emit(
        state.copyWith(
          resultType: BuyerSearchResultType.products,
          selectedCategory: initialParams.categorySlug,
        ),
      );
    } else if (initialParams.showSuppliers) {
      emit(state.copyWith(resultType: BuyerSearchResultType.suppliers));
    }
    if (!_hasValidCurrentCache) {
      unawaited(refreshResults());
    }
  }

  Future<void> _initialize() async {
    if (categoryStore.state.categories.isEmpty) {
      try {
        await categoryStore.loadCategories();
      } catch (error) {
        snackBar.error(error.toString());
      }
    }
    if (!_hasValidCurrentCache) {
      await refreshResults();
    }
  }

  void selectResultType(BuyerSearchResultType type) {
    if (state.resultType == type) return;
    _requestGeneration++;
    emit(
      state.copyWith(
        resultType: type,
        loadingResults: false,
        loadingMore: false,
      ),
    );
    if (!_hasValidCurrentCache) {
      unawaited(refreshResults());
    }
  }

  void selectCategory(String value) {
    emit(state.copyWith(selectedCategory: value));
  }

  void setInStockOnly(bool value) {
    emit(state.copyWith(inStockOnly: value));
  }

  void resetFilters() {
    emit(state.copyWith(selectedCategory: 'all-products', inStockOnly: false));
  }

  void applyFilters() {
    unawaited(refreshResults());
  }

  void onSearchChanged(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(_searchDebounce, refreshResults);
  }

  void submitSearch(String value) {
    _searchTimer?.cancel();
    unawaited(refreshResults());
  }

  void openFilters() => navigator.showProductFilters(cubit: this);

  void addProduct(Product product) {
    addToCartUseCase.execute(product: product).showFeedback(snackBar);
  }

  Future<void> pullToRefresh() => refreshResults(preserveExisting: true);

  Future<void> refreshResults({bool preserveExisting = false}) async {
    final generation = ++_requestGeneration;
    final productResults = state.resultType == BuyerSearchResultType.products;
    final signature = _signatureFor(state.resultType);
    emit(
      state.copyWith(
        loadingResults: true,
        loadingMore: false,
        products: productResults && !preserveExisting
            ? const []
            : state.products,
        suppliers: !productResults && !preserveExisting
            ? const []
            : state.suppliers,
        productHasNextPage: productResults ? false : state.productHasNextPage,
        productNextCursor: productResults ? () => null : null,
        productTotalCount: productResults && !preserveExisting
            ? 0
            : state.productTotalCount,
        supplierHasNextPage: productResults ? state.supplierHasNextPage : false,
        supplierNextCursor: productResults ? null : () => null,
        supplierTotalCount: !productResults && !preserveExisting
            ? 0
            : state.supplierTotalCount,
      ),
    );
    try {
      if (productResults) {
        final result = await _fetchProducts();
        if (generation != _requestGeneration) return;
        emit(
          state.copyWith(
            products: _applyAvailabilityFilter(result.items),
            productHasNextPage: result.hasNextPage,
            productNextCursor: () => result.nextCursor,
            productTotalCount: result.totalCount ?? result.items.length,
            productSignature: signature,
          ),
        );
      } else {
        final result = await _fetchOrganizations();
        if (generation != _requestGeneration) return;
        emit(
          state.copyWith(
            suppliers: result.items,
            supplierHasNextPage: result.hasNextPage,
            supplierNextCursor: () => result.nextCursor,
            supplierTotalCount: result.totalCount ?? result.items.length,
            supplierSignature: signature,
          ),
        );
      }
    } catch (error) {
      if (generation == _requestGeneration) {
        snackBar.error(error.toString());
      }
    } finally {
      if (generation == _requestGeneration) {
        emit(state.copyWith(loadingResults: false));
      }
    }
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (state.loadingResults ||
        state.loadingMore ||
        !state.hasNextPage ||
        cursor == null) {
      return;
    }
    final generation = _requestGeneration;
    emit(state.copyWith(loadingMore: true));
    try {
      if (state.resultType == BuyerSearchResultType.products) {
        final result = await _fetchProducts(cursor: cursor);
        if (generation != _requestGeneration) return;
        emit(
          state.copyWith(
            products: _deduplicateProducts([
              ...state.products,
              ..._applyAvailabilityFilter(result.items),
            ]),
            productHasNextPage: result.hasNextPage,
            productNextCursor: () => result.nextCursor,
          ),
        );
      } else {
        final result = await _fetchOrganizations(cursor: cursor);
        if (generation != _requestGeneration) return;
        emit(
          state.copyWith(
            suppliers: _deduplicateOrganizations([
              ...state.suppliers,
              ...result.items,
            ]),
            supplierHasNextPage: result.hasNextPage,
            supplierNextCursor: () => result.nextCursor,
          ),
        );
      }
    } catch (error) {
      if (generation == _requestGeneration) {
        snackBar.error(error.toString());
      }
    } finally {
      if (generation == _requestGeneration) {
        emit(state.copyWith(loadingMore: false));
      }
    }
  }

  Future<PaginatedResult<Organization>> _fetchOrganizations({String? cursor}) {
    return getOrganizationsUseCase.execute(
      request: OrganizationListingRequest(
        limit: _limit,
        cursor: cursor,
        query: searchController.text,
      ),
    );
  }

  bool get _hasValidCurrentCache {
    final type = state.resultType;
    final hasItems = type == BuyerSearchResultType.products
        ? state.products.isNotEmpty
        : state.suppliers.isNotEmpty;
    final signature = type == BuyerSearchResultType.products
        ? state.productSignature
        : state.supplierSignature;
    return hasItems && signature == _signatureFor(type);
  }

  String _signatureFor(BuyerSearchResultType type) {
    final query = searchController.text.trim().toLowerCase();
    if (type == BuyerSearchResultType.suppliers) return query;
    return [query, state.selectedCategory, state.inStockOnly].join('|');
  }

  Future<PaginatedResult<Product>> _fetchProducts({String? cursor}) {
    final category = selectedCategory;
    return getProductListingsUseCase.execute(
      request: ProductListingRequest(
        limit: _limit,
        cursor: cursor,
        query: searchController.text,
        categoryId: category == null || category.slug == 'all-products'
            ? null
            : category.id,
      ),
    );
  }

  List<Product> _applyAvailabilityFilter(List<Product> products) {
    if (!state.inStockOnly) return products;
    return products
        .where((product) => product.stockStatus == StockStatus.inStock)
        .toList(growable: false);
  }

  List<Product> _deduplicateProducts(List<Product> products) {
    final byId = <String, Product>{};
    for (final product in products) {
      byId.putIfAbsent(product.id, () => product);
    }
    return byId.values.toList(growable: false);
  }

  List<Organization> _deduplicateOrganizations(
    List<Organization> organizations,
  ) {
    final byId = <String, Organization>{};
    for (final organization in organizations) {
      byId.putIfAbsent(organization.id, () => organization);
    }
    return byId.values.toList(growable: false);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < 240) {
      unawaited(loadMore());
    }
  }

  void dispose() {
    _searchTimer?.cancel();
    scrollController.removeListener(_onScroll);
  }
}
