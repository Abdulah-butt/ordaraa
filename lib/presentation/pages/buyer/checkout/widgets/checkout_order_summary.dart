import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/entities/checkout_preview.dart';
import '../../../../../domain/entities/money.dart';
import '../../../../../domain/stores/cart_store_state.dart';
import '../../../../widgets/app_skeleton.dart';

class CheckoutOrderSummary extends StatelessWidget {
  const CheckoutOrderSummary({
    super.key,
    required this.cart,
    required this.preview,
    required this.previewing,
  });

  final CartStoreState cart;
  final CheckoutPreview? preview;
  final bool previewing;

  @override
  Widget build(BuildContext context) {
    if (previewing) {
      return const CheckoutOrderSummarySkeleton();
    }
    if (preview == null) {
      return const _PreviewUnavailable();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        borderRadius: AppRadius.field,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  cart.seller?.name ?? 'Order summary',
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${cart.productLineCount} '
                '${cart.productLineCount == 1 ? 'line' : 'lines'}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in cart.items) ...[
            Builder(
              builder: (context) {
                final priced = preview!.items
                    .where(
                      (previewItem) => previewItem.listingId == item.product.id,
                    )
                    .firstOrNull;
                return _LineItem(
                  title:
                      item.product.titleOverride ?? item.product.variant.label,
                  quantity: '${item.quantity} ${item.product.priceUnit.code}',
                  total: priced?.lineSubtotal ?? item.product.price,
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const Divider(),
          _MoneyRow(label: 'Subtotal', money: preview!.subtotal),
          if ((double.tryParse(preview!.discountTotal.amount) ?? 0) > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            _MoneyRow(
              label: 'Discount',
              money: preview!.discountTotal,
              subtract: true,
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          _MoneyRow(label: 'Delivery', money: preview!.deliveryFee),
          const SizedBox(height: AppSpacing.xs),
          _MoneyRow(label: 'Tax', money: preview!.taxTotal),
          const SizedBox(height: AppSpacing.sm),
          _MoneyRow(label: 'Total', money: preview!.total, emphasized: true),
        ],
      ),
    );
  }
}

class CheckoutOrderSummarySkeleton extends StatelessWidget {
  const CheckoutOrderSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        borderRadius: AppRadius.field,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeletonBox(width: 156, height: 16),
          SizedBox(height: AppSpacing.lg),
          AppSkeletonBox(height: 13),
          SizedBox(height: AppSpacing.sm),
          AppSkeletonBox(width: 210, height: 11),
          SizedBox(height: AppSpacing.lg),
          Divider(),
          AppSkeletonBox(height: 12),
          SizedBox(height: AppSpacing.sm),
          AppSkeletonBox(height: 12),
          SizedBox(height: AppSpacing.sm),
          AppSkeletonBox(height: 17),
        ],
      ),
    );
  }
}

class _PreviewUnavailable extends StatelessWidget {
  const _PreviewUnavailable();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        borderRadius: AppRadius.field,
      ),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: context.colorTheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Choose a delivery address to calculate the final order total.',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem({
    required this.title,
    required this.quantity,
    required this.total,
  });

  final String title;
  final String quantity;
  final Money total;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                quantity,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          total.formatted,
          style: context.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.money,
    this.emphasized = false,
    this.subtract = false,
  });

  final String label;
  final Money money;
  final bool emphasized;
  final bool subtract;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          '${subtract ? '−' : ''}${money.formatted}',
          style: context.textTheme.labelMedium?.copyWith(
            color: emphasized
                ? context.colorTheme.primary
                : context.colorTheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
