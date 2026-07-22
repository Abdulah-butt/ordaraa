import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/entities/category.dart';
import '../../../../../domain/stores/category_store.dart';
import '../../../../../domain/stores/category_store_state.dart';
import '../buyer_home_state.dart';
import 'buyer_category_shortcuts.dart';
import 'buyer_home_app_bar.dart';
import 'buyer_home_search.dart';
import 'buyer_reorder_card.dart';
import 'home_section_header.dart';
import '../../../../widgets/buyer_product_card.dart';
import '../../../../widgets/buyer_supplier_card.dart';

class BuyerHomeContent extends StatelessWidget {
  const BuyerHomeContent({
    super.key,
    required this.state,
    required this.categoryStore,
    required this.onCategorySelected,
    required this.onViewAllCategories,
  });

  final BuyerHomeState state;
  final CategoryStore categoryStore;
  final ValueChanged<Category> onCategorySelected;
  final VoidCallback onViewAllCategories;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BuyerHomeAppBar(deliveryLocation: state.deliveryLocation),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            sliver: SliverList.list(
              children: [
                const BuyerHomeSearch(),
                const SizedBox(height: 12),
                BuyerReorderCard(description: state.reorderDescription),
                const SizedBox(height: 12),
                BlocBuilder<CategoryStore, CategoryStoreState>(
                  bloc: categoryStore,
                  buildWhen: (previous, current) =>
                      previous.categories != current.categories ||
                      previous.loading != current.loading,
                  builder: (context, categoryState) {
                    final categories = categoryState.categories
                        .where((category) => category.slug != 'all-products')
                        .take(3)
                        .toList(growable: false);
                    return BuyerCategoryShortcuts(
                      categories: categories,
                      loading: categoryState.loading,
                      onSelected: onCategorySelected,
                      onViewAll: onViewAllCategories,
                    );
                  },
                ),
                const SizedBox(height: 12),
                const HomeSectionHeader(title: 'Recommended for your business'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 252,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.products.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return BuyerProductCard(product: state.products[index]);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const HomeSectionHeader(title: 'Suppliers serving Sydney'),
                const SizedBox(height: 8),
                for (
                  var index = 0;
                  index < state.suppliers.length;
                  index++
                ) ...[
                  BuyerSupplierCard(supplier: state.suppliers[index]),
                  if (index != state.suppliers.length - 1)
                    const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
