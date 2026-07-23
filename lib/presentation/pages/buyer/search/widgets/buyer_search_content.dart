import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../widgets/buyer_product_card.dart';
import '../../../../widgets/buyer_supplier_card.dart';
import '../../../../widgets/app_skeleton.dart';
import '../../../../widgets/app_pull_to_refresh.dart';
import '../../../../widgets/pinned_sliver_header.dart';
import '../buyer_search_cubit.dart';
import '../buyer_search_state.dart';

class BuyerSearchContent extends StatelessWidget {
  const BuyerSearchContent({
    super.key,
    required this.cubit,
    required this.state,
  });

  final BuyerSearchCubit cubit;
  final BuyerSearchState state;

  @override
  Widget build(BuildContext context) {
    final products = state.resultType == BuyerSearchResultType.products;
    final selectedCategoryName = state.selectedCategory == 'all-products'
        ? null
        : cubit.selectedCategory?.name;
    final visibleResultsAreEmpty = products
        ? state.products.isEmpty
        : state.suppliers.isEmpty;
    return SafeArea(
      bottom: false,
      child: AppPullToRefresh(
        onRefresh: cubit.pullToRefresh,
        child: CustomScrollView(
          controller: cubit.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            PinnedSliverHeader(
              height: 184,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      products ? 'Search' : 'Suppliers',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      products
                          ? 'Find a product or browse a supplier’s catalogue.'
                          : 'Verified businesses serving Sydney, NSW',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SearchField(
                      controller: cubit.searchController,
                      hint: products
                          ? 'Search products or suppliers'
                          : 'Search business name',
                      onChanged: cubit.onSearchChanged,
                      onSubmitted: cubit.submitSearch,
                    ),
                    const SizedBox(height: 10),
                    _SearchControls(
                      state: state,
                      onTypeSelected: cubit.selectResultType,
                      onFilters: cubit.openFilters,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList.list(
                children: [
                  if (products && selectedCategoryName != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _SelectedCategoryChip(value: selectedCategoryName),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          products
                              ? 'Products'
                              : 'Suppliers serving this address',
                          style: context.textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${state.totalCount} results',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (state.loadingResults && visibleResultsAreEmpty)
                    AppSkeleton(
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: index == 2 ? 0 : 12,
                            ),
                            child: products
                                ? const ProductCardSkeleton(detailed: true)
                                : const SupplierCardSkeleton(detailed: true),
                          ),
                        ),
                      ),
                    )
                  else if (products && state.products.isEmpty)
                    const SizedBox(
                      height: 180,
                      child: Center(child: Text('No products found')),
                    )
                  else if (products)
                    for (var i = 0; i < state.products.length; i++) ...[
                      BuyerProductCard(
                        product: state.products[i],
                        layout: BuyerProductCardLayout.detailed,
                        onTap: () =>
                            cubit.navigator.openProduct(state.products[i].id),
                        onAdd: () => cubit.addProduct(state.products[i]),
                      ),
                      if (i != state.products.length - 1)
                        const SizedBox(height: 12),
                    ]
                  else if (state.suppliers.isEmpty)
                    const SizedBox(
                      height: 180,
                      child: Center(child: Text('No suppliers found')),
                    )
                  else
                    for (var i = 0; i < state.suppliers.length; i++) ...[
                      BuyerSupplierCard(
                        supplier: state.suppliers[i],
                        layout: BuyerSupplierCardLayout.detailed,
                        onTap: () =>
                            cubit.navigator.openSeller(state.suppliers[i].id),
                      ),
                      if (i != state.suppliers.length - 1)
                        const SizedBox(height: 14),
                    ],
                  if (state.loadingMore) ...[
                    const SizedBox(height: 18),
                    AppSkeleton(
                      child: products
                          ? const ProductCardSkeleton(detailed: true)
                          : const SupplierCardSkeleton(detailed: true),
                    ),
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

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: context.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 10, 16),
          child: SvgPicture.asset(
            Assets.buyerHomeSearch,
            width: 20,
            height: 20,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.colorTheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.colorTheme.outlineVariant),
        ),
      ),
    ),
  );
}

class _SearchControls extends StatelessWidget {
  const _SearchControls({
    required this.state,
    required this.onTypeSelected,
    required this.onFilters,
  });

  final BuyerSearchState state;
  final ValueChanged<BuyerSearchResultType> onTypeSelected;
  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Container(
          height: 38,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.ordaraColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: BuyerSearchResultType.values
                .map(
                  (type) => Expanded(
                    child: _ResultTab(
                      label: type == BuyerSearchResultType.products
                          ? 'Products'
                          : 'Suppliers',
                      selected: state.resultType == type,
                      onTap: () => onTypeSelected(type),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      const SizedBox(width: 10),
      if (state.resultType == BuyerSearchResultType.products)
        SizedBox(
          width: 122,
          height: 38,
          child: OutlinedButton.icon(
            onPressed: onFilters,
            icon: SvgPicture.asset(
              Assets.buyerSearchFilter,
              width: 16,
              height: 16,
            ),
            label: const Text('Filters'),
          ),
        ),
    ],
  );
}

class _ResultTab extends StatelessWidget {
  const _ResultTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? context.colorTheme.surface : Colors.transparent,
    borderRadius: BorderRadius.circular(9),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Center(
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: selected
                ? context.colorTheme.primary
                : context.colorTheme.onSurfaceVariant,
          ),
        ),
      ),
    ),
  );
}

class _SelectedCategoryChip extends StatelessWidget {
  const _SelectedCategoryChip({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 30,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: context.colorTheme.primaryContainer,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: context.colorTheme.primary),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.buyerSearchCheck, width: 12, height: 12),
        const SizedBox(width: 5),
        Text(
          value,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorTheme.primary,
            fontSize: 10,
            height: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
