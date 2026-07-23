import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/entities/category.dart';
import '../../../../../domain/entities/product.dart';
import '../../../../../domain/stores/category_store.dart';
import '../../../../../domain/stores/category_store_state.dart';
import '../buyer_home_state.dart';
import 'buyer_category_shortcuts.dart';
import 'buyer_home_app_bar.dart';
import 'buyer_home_search.dart';
import 'home_section_header.dart';
import '../../../../widgets/buyer_product_card.dart';
import '../../../../widgets/buyer_supplier_card.dart';
import '../../../../widgets/app_skeleton.dart';
import '../../../../widgets/app_pull_to_refresh.dart';
import '../../../../widgets/pinned_sliver_header.dart';

class BuyerHomeContent extends StatelessWidget {
  const BuyerHomeContent({
    super.key,
    required this.state,
    required this.categoryStore,
    required this.onCategorySelected,
    required this.onViewAllCategories,
    required this.onViewAllProducts,
    required this.onViewAllSuppliers,
    required this.onRefresh,
    required this.onProductSelected,
    required this.onProductAdd,
    required this.onSellerSelected,
    required this.onCartTap,
  });

  final BuyerHomeState state;
  final CategoryStore categoryStore;
  final ValueChanged<Category> onCategorySelected;
  final VoidCallback onViewAllCategories;
  final VoidCallback onViewAllProducts;
  final VoidCallback onViewAllSuppliers;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onProductSelected;
  final ValueChanged<Product> onProductAdd;
  final ValueChanged<String> onSellerSelected;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: AppPullToRefresh(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            PinnedSliverHeader(
              height: 138,
              child: Column(
                children: [
                  BuyerHomeAppBar(
                    deliveryLocation: state.deliveryLocation,
                    onCartTap: onCartTap,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
                    child: BuyerHomeSearch(),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.list(
                children: [
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
                  HomeSectionHeader(
                    title: 'Recommended for your business',
                    onSeeAll: onViewAllProducts,
                  ),
                  const SizedBox(height: 8),
                  if (state.loadingProducts && state.products.isEmpty)
                    SizedBox(
                      height: 252,
                      child: AppSkeleton(
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (_, _) => const ProductCardSkeleton(),
                        ),
                      ),
                    )
                  else if (state.products.isEmpty)
                    const SizedBox(
                      height: 80,
                      child: Center(child: Text('No products available')),
                    )
                  else
                    SizedBox(
                      height: 252,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.products.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return BuyerProductCard(
                            product: state.products[index],
                            onTap: () =>
                                onProductSelected(state.products[index].id),
                            onAdd: () => onProductAdd(state.products[index]),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 12),
                  HomeSectionHeader(
                    title: 'Suppliers in your market',
                    onSeeAll: onViewAllSuppliers,
                  ),
                  const SizedBox(height: 8),
                  if (state.loadingSuppliers && state.suppliers.isEmpty)
                    const AppSkeleton(
                      child: Column(
                        children: [
                          SupplierCardSkeleton(),
                          SizedBox(height: 8),
                          SupplierCardSkeleton(),
                        ],
                      ),
                    )
                  else if (state.suppliers.isEmpty)
                    const SizedBox(
                      height: 80,
                      child: Center(child: Text('No suppliers available')),
                    )
                  else
                    for (
                      var index = 0;
                      index < state.suppliers.length;
                      index++
                    ) ...[
                      BuyerSupplierCard(
                        supplier: state.suppliers[index],
                        onTap: () =>
                            onSellerSelected(state.suppliers[index].id),
                      ),
                      if (index != state.suppliers.length - 1)
                        const SizedBox(height: 8),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
