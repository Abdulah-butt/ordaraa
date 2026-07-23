import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/entities/cart_item.dart';
import '../../../../widgets/custom_cache_image.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final image =
        product.images.firstOrNull?.thumbnailUrl ??
        product.images.firstOrNull?.url;
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colorTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colorTheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(11),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: image == null
                    ? ColoredBox(
                        color: context.colorTheme.surfaceContainerLow,
                        child: const SizedBox.square(
                          dimension: 84,
                          child: Icon(Icons.image_not_supported_outlined),
                        ),
                      )
                    : CustomCacheImage(
                        imgUrl: image,
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: onTap,
                    child: Text(
                      product.titleOverride ?? product.variant.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${product.priceUnit.label} · '
                    '${product.minimumOrderQuantity} minimum',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${product.price.formatted} / ${product.priceUnit.code}',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _QuantityStepper(
                        quantity: item.quantity,
                        onIncrement: onIncrement,
                        onDecrement: onDecrement,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: onRemove,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(44, 30),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorTheme.error,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: AppRadius.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(icon: Icons.remove_rounded, onTap: onDecrement),
          SizedBox(
            width: 30,
            child: Text(
              NumberFormat.decimalPattern().format(quantity),
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.chip,
      child: SizedBox.square(
        dimension: 30,
        child: Icon(icon, size: AppSizes.iconXs),
      ),
    );
  }
}
