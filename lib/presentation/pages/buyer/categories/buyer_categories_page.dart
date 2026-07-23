import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/utils/assets.dart';
import '../../../../domain/stores/category_store.dart';
import '../../../../domain/stores/category_store_state.dart';
import '../../../widgets/buyer_category_grid.dart';
import 'buyer_categories_cubit.dart';
import 'buyer_categories_initial_params.dart';

class BuyerCategoriesPage extends StatefulWidget {
  const BuyerCategoriesPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/categories';
  final BuyerCategoriesCubit cubit;
  final BuyerCategoriesInitialParams initialParams;

  @override
  State<BuyerCategoriesPage> createState() => _BuyerCategoriesPageState();
}

class _BuyerCategoriesPageState extends State<BuyerCategoriesPage> {
  BuyerCategoriesCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.surfaceContainerLow,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CategoryStore, CategoryStoreState>(
          bloc: cubit.categoryStore,
          builder: (context, categoryState) {
            final categories = categoryState.categories;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _CategoriesHeader(onBack: cubit.navigator.goBack),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All categories',
                          style: context.textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap a category to view available products.',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                if (categoryState.loading && categories.isEmpty)
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: BuyerCategoryGridSkeletonSliver(),
                  )
                else if (categoryState.errorMessage != null &&
                    categories.isEmpty)
                  SliverFillRemaining(
                    child: _CategoriesError(onRetry: cubit.retry),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: BuyerCategoryGridSliver(
                      categories: categories,
                      onCategoryTap: cubit.selectCategory,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoriesError extends StatelessWidget {
  const _CategoriesError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cloud_off_outlined,
          size: 36,
          color: context.colorTheme.onSurfaceVariant,
        ),
        const SizedBox(height: 10),
        Text('Unable to load categories', style: context.textTheme.titleMedium),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Container(
    height: 76,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    color: context.colorTheme.surface,
    child: Row(
      children: [
        Material(
          color: context.colorTheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: context.colorTheme.outlineVariant),
          ),
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox.square(
              dimension: 42,
              child: Center(
                child: SvgPicture.asset(
                  Assets.chevronLeft,
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse categories',
              maxLines: 1,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'Choose a category to explore products',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w400,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
