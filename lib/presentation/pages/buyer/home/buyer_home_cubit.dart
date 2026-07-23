import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/extensions/add_to_cart_result_extension.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/stores/category_store.dart';
import '../../../../domain/usecases/get_organizations_use_case.dart';
import '../../../../domain/usecases/get_product_listings_use_case.dart';
import '../../../../domain/usecases/add_to_cart_use_case.dart';
import '../../../../network/request_model/organization_listing_request.dart';
import '../../../../network/request_model/product_listing_request.dart';
import '../categories/buyer_categories_initial_params.dart';
import '../search/buyer_search_initial_params.dart';
import '../product_detail/product_detail_initial_params.dart';
import '../seller_detail/seller_detail_initial_params.dart';
import 'buyer_home_initial_params.dart';
import 'buyer_home_navigator.dart';
import 'buyer_home_state.dart';

class BuyerHomeCubit extends Cubit<BuyerHomeState> {
  BuyerHomeCubit({
    required this.navigator,
    required this.categoryStore,
    required this.snackBar,
    required this.getProductListingsUseCase,
    required this.getOrganizationsUseCase,
    required this.addToCartUseCase,
  }) : super(BuyerHomeState.initial());

  final BuyerHomeNavigator navigator;
  final CategoryStore categoryStore;
  final AppSnackBar snackBar;
  final GetProductListingsUseCase getProductListingsUseCase;
  final GetOrganizationsUseCase getOrganizationsUseCase;
  final AddToCartUseCase addToCartUseCase;

  Future<void> onInit(BuyerHomeInitialParams initialParams) async {
    emit(state.copyWith(deliveryLocation: 'Sydney NSW 2000'));
    await Future.wait([
      _loadCategories(),
      _loadRecommendedProducts(),
      _loadRecommendedSuppliers(),
    ]);
  }

  Future<void> refresh() async {
    await Future.wait([
      _loadCategories(forceRefresh: true),
      _loadRecommendedProducts(forceRefresh: true),
      _loadRecommendedSuppliers(forceRefresh: true),
    ]);
  }

  Future<void> _loadRecommendedSuppliers({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        (state.suppliers.isNotEmpty || state.loadingSuppliers)) {
      return;
    }
    emit(state.copyWith(loadingSuppliers: true));
    try {
      final result = await getOrganizationsUseCase.execute(
        request: const OrganizationListingRequest(limit: 5),
      );
      emit(state.copyWith(suppliers: result.items));
    } catch (error) {
      snackBar.error(error.toString());
    } finally {
      emit(state.copyWith(loadingSuppliers: false));
    }
  }

  Future<void> _loadCategories({bool forceRefresh = false}) async {
    try {
      await categoryStore.loadCategories(forceRefresh: forceRefresh);
    } catch (error) {
      snackBar.error(error.toString());
    }
  }

  Future<void> _loadRecommendedProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && (state.products.isNotEmpty || state.loadingProducts)) {
      return;
    }
    emit(state.copyWith(loadingProducts: true));
    try {
      final result = await getProductListingsUseCase.execute(
        request: const ProductListingRequest(limit: 5),
      );
      emit(state.copyWith(products: result.items));
    } catch (error) {
      snackBar.error(error.toString());
    } finally {
      emit(state.copyWith(loadingProducts: false));
    }
  }

  void selectCategory(Category category) {
    navigator.openBuyerSearch(
      BuyerSearchInitialParams(categorySlug: category.slug),
    );
  }

  void viewAllCategories() {
    navigator.openBuyerCategories(const BuyerCategoriesInitialParams());
  }

  void viewAllProducts() {
    navigator.openBuyerSearch(const BuyerSearchInitialParams());
  }

  void viewAllSuppliers() {
    navigator.openBuyerSearch(
      const BuyerSearchInitialParams(showSuppliers: true),
    );
  }

  void openProduct(String productId) {
    navigator.openProductDetail(
      ProductDetailInitialParams(productId: productId),
    );
  }

  void openSeller(String sellerId) {
    navigator.openSellerDetail(SellerDetailInitialParams(sellerId: sellerId));
  }

  void addProduct(Product product) {
    addToCartUseCase.execute(product: product).showFeedback(snackBar);
  }

  void openCart() => navigator.openCart();
}
