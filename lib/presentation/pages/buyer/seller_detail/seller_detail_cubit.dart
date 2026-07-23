import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/extensions/add_to_cart_result_extension.dart';
import '../../../../core/extensions/url_launcher_extension.dart';
import '../../../../domain/entities/paginated_result.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/get_organization_by_id_use_case.dart';
import '../../../../domain/usecases/get_product_listings_use_case.dart';
import '../../../../domain/usecases/add_to_cart_use_case.dart';
import '../../../../network/request_model/product_listing_request.dart';
import 'seller_detail_initial_params.dart';
import 'seller_detail_navigator.dart';
import 'seller_detail_state.dart';

class SellerDetailCubit extends Cubit<SellerDetailState> {
  SellerDetailCubit({
    required this.navigator,
    required this.getOrganizationByIdUseCase,
    required this.getProductListingsUseCase,
    required this.addToCartUseCase,
    required this.snackBar,
  }) : super(SellerDetailState.initial());

  static const _pageSize = 10;

  final SellerDetailNavigator navigator;
  final GetOrganizationByIdUseCase getOrganizationByIdUseCase;
  final GetProductListingsUseCase getProductListingsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final AppSnackBar snackBar;
  final scrollController = ScrollController();
  String? _sellerId;
  int _requestGeneration = 0;

  Future<void> onInit(SellerDetailInitialParams initialParams) async {
    scrollController
      ..removeListener(_onScroll)
      ..addListener(_onScroll);
    if (initialParams.sellerId.isEmpty) {
      emit(state.copyWith(errorMessage: () => 'Supplier ID is missing.'));
      return;
    }
    if (_sellerId == initialParams.sellerId && state.detail != null) return;
    _sellerId = initialParams.sellerId;
    await _load();
  }

  Future<void> refresh() => _load(preserveData: true);

  Future<void> retry() => _load();

  Future<void> _load({bool preserveData = false}) async {
    final sellerId = _sellerId;
    if (sellerId == null || state.loading) return;
    final generation = ++_requestGeneration;
    emit(
      state.copyWith(
        detail: preserveData ? null : () => null,
        products: preserveData ? state.products : const [],
        loading: true,
        loadingMore: false,
        hasNextPage: preserveData ? state.hasNextPage : false,
        loadedItemCount: preserveData ? state.loadedItemCount : 0,
        totalCount: preserveData ? state.totalCount : 0,
        errorMessage: () => null,
      ),
    );
    try {
      final detailFuture = getOrganizationByIdUseCase.execute(id: sellerId);
      final listingsFuture = _fetchProducts(sellerId: sellerId, offset: 0);
      final detail = await detailFuture;
      final listings = await listingsFuture;
      if (generation != _requestGeneration) return;
      emit(
        state.copyWith(
          detail: () => detail,
          products: listings.items,
          hasNextPage: listings.hasNextPage,
          loadedItemCount: listings.items.length,
          totalCount: listings.totalCount ?? listings.items.length,
        ),
      );
    } catch (error) {
      if (generation == _requestGeneration) {
        emit(state.copyWith(errorMessage: () => error.toString()));
      }
    } finally {
      if (generation == _requestGeneration) {
        emit(state.copyWith(loading: false));
      }
    }
  }

  Future<void> loadMore() async {
    final sellerId = _sellerId;
    if (sellerId == null ||
        state.loading ||
        state.loadingMore ||
        !state.hasNextPage) {
      return;
    }
    final generation = _requestGeneration;
    emit(state.copyWith(loadingMore: true));
    try {
      final result = await _fetchProducts(
        sellerId: sellerId,
        offset: state.loadedItemCount,
      );
      if (generation != _requestGeneration) return;
      emit(
        state.copyWith(
          products: [...state.products, ...result.items],
          hasNextPage: result.hasNextPage,
          loadedItemCount: state.loadedItemCount + result.items.length,
          totalCount: result.totalCount ?? state.totalCount,
        ),
      );
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

  Future<PaginatedResult<Product>> _fetchProducts({
    required String sellerId,
    required int offset,
  }) {
    return getProductListingsUseCase.execute(
      request: ProductListingRequest(
        limit: _pageSize,
        offset: offset,
        sellerOrganizationId: sellerId,
      ),
    );
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < 240) {
      unawaited(loadMore());
    }
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
  }

  void openProduct(String productId) => navigator.openProduct(productId);

  void addProduct(Product product) {
    addToCartUseCase.execute(product: product).showFeedback(snackBar);
  }

  Future<void> contactByWhatsApp() async {
    final phone = state.detail?.contactPhone;
    if (phone == null || phone.trim().isEmpty) return;
    try {
      await phone.launchWhatsApp();
    } catch (error) {
      snackBar.error(error.toString());
    }
  }

  Future<void> contactByEmail() async {
    final email = state.detail?.contactEmail;
    if (email == null || email.trim().isEmpty) return;
    try {
      await email.launchEmail();
    } catch (error) {
      snackBar.error(error.toString());
    }
  }

  Future<void> contactSeller() {
    final phone = state.detail?.contactPhone;
    return phone != null && phone.trim().isNotEmpty
        ? contactByWhatsApp()
        : contactByEmail();
  }

  void openCart() => navigator.openCart();
}
