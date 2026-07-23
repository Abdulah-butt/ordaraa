import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/theme_extension.dart';
import '../../core/enums/stock_status.dart';
import '../../core/utils/assets.dart';
import '../../domain/entities/product.dart';
import 'custom_cache_image.dart';

enum BuyerProductCardLayout { compact, detailed }

class BuyerProductCard extends StatelessWidget {
  const BuyerProductCard({
    super.key,
    required this.product,
    this.layout = BuyerProductCardLayout.compact,
    this.onTap,
    this.onAdd,
  });

  final Product product;
  final BuyerProductCardLayout layout;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return layout == BuyerProductCardLayout.compact
        ? _compact(context)
        : _detailed(context);
  }

  Widget _compact(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            width: 171,
            height: 252,
            padding: const EdgeInsets.all(10),
            decoration: _decoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image(context, width: 151, height: 88),
                const SizedBox(height: 7),
                _AvailabilityBadge(availability: product.stockStatus),
                const SizedBox(height: 7),
                _name(context, fontSize: 13),
                const Spacer(),
                _supplier(context, fontSize: 10),
                const SizedBox(height: 4),
                _packaging(context, fontSize: 10),
                const SizedBox(height: 7),
                _priceRow(context, fontSize: 11),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailed(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(10),
            decoration: _decoration(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image(context, width: 112, height: 120),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AvailabilityBadge(availability: product.stockStatus),
                      const SizedBox(height: 5),
                      _name(context, fontSize: 15, maxLines: 1),
                      const SizedBox(height: 5),
                      _supplier(context, fontSize: 11),
                      const SizedBox(height: 5),
                      _packaging(context, fontSize: 11),
                      const Spacer(),
                      _priceRow(context, fontSize: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
    color: context.colorTheme.surface,
    border: Border.all(color: context.colorTheme.outlineVariant),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: context.colorTheme.shadow.withValues(alpha: 0.06),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  Widget _image(
    BuildContext context, {
    required double width,
    required double height,
  }) {
    final imageUrl =
        product.images.firstOrNull?.thumbnailUrl ??
        product.images.firstOrNull?.url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl == null
          ? ColoredBox(
              color: context.colorTheme.surfaceContainerLow,
              child: SizedBox(
                width: width,
                height: height,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
            )
          : CustomCacheImage(
              imgUrl: imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _name(
    BuildContext context, {
    required double fontSize,
    int maxLines = 2,
  }) => Text(
    product.titleOverride ?? product.variant.label,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: context.textTheme.labelLarge?.copyWith(
      fontSize: fontSize,
      height: 19 / fontSize,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _supplier(BuildContext context, {required double fontSize}) => Row(
    children: [
      SvgPicture.asset(Assets.buyerHomeStore, width: 12, height: 12),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          '${product.seller.name}${product.seller.verified ? ' · Verified' : ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorTheme.primary,
            fontSize: fontSize,
            height: 14 / fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _packaging(BuildContext context, {required double fontSize}) => Text(
    '${product.minimumOrderQuantity} ${product.priceUnit.code} minimum',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: context.textTheme.labelSmall?.copyWith(
      fontSize: fontSize,
      height: 14 / fontSize,
      fontWeight: FontWeight.w400,
    ),
  );

  Widget _priceRow(BuildContext context, {required double fontSize}) => Row(
    children: [
      Expanded(
        child: Text(
          '${product.price.formatted} / ${product.priceUnit.code}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorTheme.onSurface,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(width: 4),
      _ProductActionButton(product: product, onTap: onAdd),
    ],
  );
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.availability});
  final StockStatus availability;

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (availability) {
      StockStatus.inStock => (
        'Available',
        context.ordaraColors.success,
        context.ordaraColors.successContainer,
      ),
      StockStatus.lowStock => (
        'Low Stock',
        context.ordaraColors.warning,
        context.ordaraColors.warningContainer,
      ),
      StockStatus.outOfStock || StockStatus.unavailable => (
        'Out of Stock',
        context.colorTheme.error,
        context.colorTheme.errorContainer,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: 10,
          height: 14 / 10,
        ),
      ),
    );
  }
}

class _ProductActionButton extends StatelessWidget {
  const _ProductActionButton({required this.product, this.onTap});
  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (product.stockStatus == StockStatus.outOfStock ||
        product.stockStatus == StockStatus.unavailable) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: context.ordaraColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Unavailable',
          style: context.textTheme.labelSmall?.copyWith(
            color: context.ordaraColors.textDisabled,
            fontSize: 10,
          ),
        ),
      );
    }
    return Material(
      color: context.colorTheme.primary,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Assets.buyerHomePlus, width: 11, height: 11),
              const SizedBox(width: 4),
              Text(
                'Add',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.onPrimary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
