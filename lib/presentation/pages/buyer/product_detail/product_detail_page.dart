import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/enums/stock_status.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/utils/assets.dart';
import '../../../../domain/entities/product.dart';
import '../../../widgets/app_pull_to_refresh.dart';
import '../../../widgets/app_skeleton.dart';
import '../../../widgets/buyer_detail_app_bar.dart';
import '../../../widgets/custom_cache_image.dart';
import 'product_detail_cubit.dart';
import 'product_detail_initial_params.dart';
import 'product_detail_state.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/product-detail';

  final ProductDetailCubit cubit;
  final ProductDetailInitialParams initialParams;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductDetailCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                BuyerDetailAppBar(
                  title: 'Product details',
                  onBack: cubit.navigator.goBack,
                  onCart: cubit.openCart,
                ),
                Expanded(
                  child: AppPullToRefresh(
                    onRefresh: cubit.refresh,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                          sliver: SliverToBoxAdapter(
                            child: _ProductDetailBody(
                              state: state,
                              onRetry: cubit.retry,
                              onSellerTap: cubit.openSeller,
                              onIncrement: cubit.incrementQuantity,
                              onDecrement: cubit.decrementQuantity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.product != null)
                  _StickyProductAction(
                    product: state.product!,
                    quantity: state.quantity,
                    onAdd: cubit.addToCart,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({
    required this.state,
    required this.onRetry,
    required this.onSellerTap,
    required this.onIncrement,
    required this.onDecrement,
  });

  final ProductDetailState state;
  final VoidCallback onRetry;
  final VoidCallback onSellerTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    if (state.loading && product == null) {
      return const _ProductDetailSkeleton();
    }
    if (product == null) {
      return _DetailError(
        message: state.errorMessage ?? 'Product could not be loaded.',
        onRetry: onRetry,
      );
    }

    final title = product.titleOverride ?? product.variant.label;
    final image =
        product.images.firstOrNull?.thumbnailUrl ??
        product.images.firstOrNull?.url;
    final specifications = <String>[
      if (product.variant.size != null) product.variant.size!,
      if (product.variant.grade != null) product.variant.grade!,
      if (product.variant.form != null) product.variant.form!,
      if (product.variant.originCountryCode != null)
        '${product.variant.originCountryCode} origin',
      if (product.variant.preservation != null) product.variant.preservation!,
      if (product.sellerSku != null) 'SKU ${product.sellerSku}',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: image == null
              ? Container(
                  height: 190,
                  width: double.infinity,
                  color: context.colorTheme.surfaceContainerLow,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported_outlined),
                )
              : CustomCacheImage(
                  imgUrl: image,
                  height: 190,
                  width: double.infinity,
                ),
        ),
        const SizedBox(height: 10),
        _AvailabilityBadge(status: product.stockStatus),
        const SizedBox(height: 10),
        Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onSellerTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                SvgPicture.asset(Assets.buyerHomeStore, width: 13, height: 13),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '${product.seller.name}'
                    '${product.seller.verified ? ' · Verified supplier' : ''}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _PriceCard(product: product),
        if (specifications.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: specifications
                .map((specification) => _SpecChip(label: specification))
                .toList(growable: false),
          ),
        ],
        if (product.descriptionOverride != null) ...[
          const SizedBox(height: 12),
          Text(
            product.descriptionOverride!,
            style: context.textTheme.bodySmall,
          ),
        ],
        if (product.deliveryTerms != null || product.leadTimeHours != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: context.colorTheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.deliveryTerms ??
                  'Typical lead time: ${product.leadTimeHours} hours.',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorTheme.primary,
                fontSize: 10,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          'Quantity (${product.priceUnit.code})',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        _QuantityStepper(
          quantity: state.quantity,
          minimum: (num.tryParse(product.minimumOrderQuantity) ?? 1).ceil(),
          onIncrement: onIncrement,
          onDecrement: onDecrement,
        ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${product.price.formatted} / ${product.priceUnit.code}',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Minimum ${product.minimumOrderQuantity} '
                  '${product.priceUnit.label.toLowerCase()}',
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          if (product.variant.preservation != null)
            _SpecChip(label: product.variant.preservation!, selected: true),
        ],
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.status});
  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    final available =
        status == StockStatus.inStock || status == StockStatus.lowStock;
    final label = switch (status) {
      StockStatus.inStock => 'Available',
      StockStatus.lowStock => 'Low stock',
      StockStatus.outOfStock => 'Out of stock',
      StockStatus.unavailable => 'Unavailable',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: available
            ? context.ordaraColors.successContainer
            : context.colorTheme.errorContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: available
              ? context.ordaraColors.success
              : context.colorTheme.error,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: selected
            ? context.colorTheme.primaryContainer
            : context.colorTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: selected
              ? context.colorTheme.primary
              : context.colorTheme.onSurfaceVariant,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.minimum,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final int minimum;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      height: 48,
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: quantity <= minimum ? null : onDecrement,
            icon: const Icon(Icons.remove, size: 16),
          ),
          Text(
            '$quantity',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 16),
          ),
        ],
      ),
    );
  }
}

class _StickyProductAction extends StatelessWidget {
  const _StickyProductAction({
    required this.product,
    required this.quantity,
    required this.onAdd,
  });

  final Product product;
  final int quantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final amount = (double.tryParse(product.price.amount) ?? 0) * quantity;
    final total = NumberFormat.currency(
      name: product.price.currency,
      symbol: '${product.price.currency} ',
    ).format(amount);
    final unavailable =
        product.stockStatus == StockStatus.outOfStock ||
        product.stockStatus == StockStatus.unavailable;
    return ColoredBox(
      color: context.colorTheme.surface,
      child: SafeArea(
        top: false,
        child: Container(
          height: 76,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: context.colorTheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated total',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      total,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 184,
                height: 52,
                child: FilledButton(
                  onPressed: unavailable ? null : onAdd,
                  child: Text(unavailable ? 'Unavailable' : 'Add to cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: double.infinity, height: 190, uniRadius: 18),
          SizedBox(height: 12),
          Bone(width: 92, height: 24, uniRadius: 12),
          SizedBox(height: 12),
          Bone(width: 280, height: 28, uniRadius: 7),
          SizedBox(height: 10),
          Bone(width: 190, height: 14, uniRadius: 5),
          SizedBox(height: 12),
          Bone(width: double.infinity, height: 78, uniRadius: 16),
          SizedBox(height: 12),
          Bone(width: 240, height: 30, uniRadius: 15),
          SizedBox(height: 12),
          Bone(width: double.infinity, height: 40, uniRadius: 12),
        ],
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: context.colorTheme.onSurfaceVariant,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
