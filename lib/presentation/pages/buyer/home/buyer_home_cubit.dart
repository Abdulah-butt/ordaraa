import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/utils/assets.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/stores/category_store.dart';
import '../../../view_data/buyer_catalog_view_data.dart';
import '../categories/buyer_categories_initial_params.dart';
import '../search/buyer_search_initial_params.dart';
import 'buyer_home_initial_params.dart';
import 'buyer_home_navigator.dart';
import 'buyer_home_state.dart';

class BuyerHomeCubit extends Cubit<BuyerHomeState> {
  BuyerHomeCubit({
    required this.navigator,
    required this.categoryStore,
    required this.snackBar,
  }) : super(BuyerHomeState.initial());

  final BuyerHomeNavigator navigator;
  final CategoryStore categoryStore;
  final AppSnackBar snackBar;

  Future<void> onInit(BuyerHomeInitialParams initialParams) async {
    emit(
      state.copyWith(
        deliveryLocation: 'Sydney NSW 2000',
        reorderDescription: '8 items from Sydney Seafood Co.',
        products: const [
          BuyerProductViewData(
            name: 'Atlantic Salmon Portions',
            imageAsset: Assets.buyerHomeSalmon,
            availability: BuyerProductAvailability.available,
            supplier: 'Sydney Seafood · Verified',
            packaging: '10 kg case · Min. 5',
            price: 'AUD 84.00 / case',
          ),
          BuyerProductViewData(
            name: 'Australian King Prawns',
            imageAsset: Assets.buyerHomePrawns,
            availability: BuyerProductAvailability.lowStock,
            supplier: 'Harbour Catch · Verified',
            packaging: '5 kg case · Min. 3',
            price: 'AUD 96.00 / case',
          ),
        ],
        suppliers: const [
          BuyerSupplierViewData(
            name: 'Sydney Seafood Co.',
            status: 'Verified supplier',
            serviceArea: 'Greater Sydney Area · Delivery & pickup',
            deliveryDetails: 'Delivery & pickup · 1–2 days',
            catalogSummary: '42 products · Minimum order AUD 250',
          ),
        ],
      ),
    );
    if (categoryStore.state.categories.isNotEmpty) return;
    try {
      await categoryStore.loadCategories();
    } catch (error) {
      snackBar.error(error.toString());
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
}
