import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/assets.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/stores/category_store.dart';
import '../../../view_data/buyer_catalog_view_data.dart';
import 'buyer_search_initial_params.dart';
import 'buyer_search_navigator.dart';
import 'buyer_search_state.dart';

class BuyerSearchCubit extends Cubit<BuyerSearchState> {
  BuyerSearchCubit({required this.navigator, required this.categoryStore})
    : super(BuyerSearchState.initial());

  final BuyerSearchNavigator navigator;
  final CategoryStore categoryStore;
  final searchController = TextEditingController();

  List<Category> get categories => categoryStore.state.categories;

  Category? get selectedCategory => categories
      .where((category) => category.slug == state.selectedCategory)
      .firstOrNull;

  void onInit(BuyerSearchInitialParams initialParams) {
    emit(
      state.copyWith(
        products: _products,
        suppliers: _suppliers,
        selectedCategory: initialParams.categorySlug ?? 'all-products',
        resultType: BuyerSearchResultType.products,
      ),
    );
  }

  void selectResultType(BuyerSearchResultType type) =>
      emit(state.copyWith(resultType: type));
  void selectCategory(String value) =>
      emit(state.copyWith(selectedCategory: value));
  void setInStockOnly(bool value) => emit(state.copyWith(inStockOnly: value));
  void resetFilters() =>
      emit(state.copyWith(selectedCategory: 'all-products', inStockOnly: true));
  void openFilters() => navigator.showProductFilters(cubit: this);

  void dispose() => searchController.clear();

  static const _products = [
    BuyerProductViewData(
      name: 'Atlantic Salmon Portions',
      imageAsset: Assets.buyerSearchSalmon,
      availability: BuyerProductAvailability.available,
      supplier: 'Sydney Seafood Co. · Verified',
      packaging: '10 kg case · Minimum 5 cases',
      price: 'AUD 84.00 / case',
    ),
    BuyerProductViewData(
      name: 'Australian King Prawns',
      imageAsset: Assets.buyerSearchPrawns,
      availability: BuyerProductAvailability.lowStock,
      supplier: 'Harbour Catch · Verified',
      packaging: '5 kg case · Minimum 3 cases',
      price: 'AUD 96.00 / case',
    ),
    BuyerProductViewData(
      name: 'Premium Sydney Oysters',
      imageAsset: Assets.buyerSearchOysters,
      availability: BuyerProductAvailability.outOfStock,
      supplier: 'Coastal Shellfish · Verified',
      packaging: '12 dozen carton · Minimum 2 cartons',
      price: 'AUD 118.00 / carton',
    ),
  ];

  static const _suppliers = [
    BuyerSupplierViewData(
      name: 'Sydney Seafood Co.',
      serviceArea: 'Greater Sydney Area',
      deliveryDetails: 'Delivery & pickup · 1–2 days',
      catalogSummary: '42 products · Minimum order AUD 250',
    ),
    BuyerSupplierViewData(
      name: 'Harbour Catch Wholesale',
      serviceArea: 'Sydney & Northern Beaches',
      deliveryDetails: 'Delivery · Next business day',
      catalogSummary: '28 products · Minimum order AUD 180',
    ),
    BuyerSupplierViewData(
      name: 'Coastal Shellfish Co.',
      serviceArea: 'Sydney & Wollongong',
      deliveryDetails: 'Delivery & pickup · 2 days',
      catalogSummary: '18 products · Minimum order AUD 200',
    ),
  ];
}
