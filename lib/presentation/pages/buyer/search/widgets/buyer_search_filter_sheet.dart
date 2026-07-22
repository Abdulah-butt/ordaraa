import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../widgets/custom_button.dart';
import '../buyer_search_cubit.dart';
import '../buyer_search_state.dart';

class BuyerSearchFilterSheet extends StatelessWidget {
  const BuyerSearchFilterSheet({super.key, required this.cubit});
  final BuyerSearchCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyerSearchCubit, BuyerSearchState>(
      bloc: cubit,
      builder: (context, state) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter products',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: cubit.resetFilters,
                  child: const Text('Clear all'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: cubit.categories
                          .map(
                            (category) => ChoiceChip(
                              label: Text(
                                category.slug == 'all-products'
                                    ? 'All'
                                    : category.name,
                              ),
                              selected: state.selectedCategory == category.slug,
                              onSelected: (_) =>
                                  cubit.selectCategory(category.slug),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Availability',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 56,
                      padding: const EdgeInsets.only(left: 14, right: 8),
                      decoration: BoxDecoration(
                        color: context.colorTheme.surfaceContainerLow,
                        border: Border.all(
                          color: context.colorTheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'In stock only',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                        color: context.colorTheme.onSurface,
                                      ),
                                ),
                                Text(
                                  'Hide unavailable products',
                                  style: context.textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: state.inStockOnly,
                            onChanged: cubit.setInStockOnly,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Supplier',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: context.colorTheme.surface,
                        border: Border.all(
                          color: context.colorTheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'All suppliers',
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.colorTheme.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: context.colorTheme.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 108,
                  child: CustomButton(
                    text: 'Reset',
                    height: 52,
                    isSecondary: true,
                    onTap: cubit.resetFilters,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: 'Show ${state.resultCount} products',
                    height: 52,
                    onTap: context.pop,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
