import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/stores/category_store.dart';
import '../search/buyer_search_initial_params.dart';
import 'buyer_categories_initial_params.dart';
import 'buyer_categories_navigator.dart';
import 'buyer_categories_state.dart';

class BuyerCategoriesCubit extends Cubit<BuyerCategoriesState> {
  BuyerCategoriesCubit({
    required this.navigator,
    required this.categoryStore,
    required this.snackBar,
  }) : super(BuyerCategoriesState.initial());

  final BuyerCategoriesNavigator navigator;
  final CategoryStore categoryStore;
  final AppSnackBar snackBar;

  List<Category> get categories => categoryStore.state.categories;

  Future<void> onInit(BuyerCategoriesInitialParams initialParams) async {
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

  Future<void> retry() async {
    try {
      await categoryStore.loadCategories(forceRefresh: true);
    } catch (error) {
      snackBar.error(error.toString());
    }
  }
}
