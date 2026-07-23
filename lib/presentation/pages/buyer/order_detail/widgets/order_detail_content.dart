import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/enums/order_status.dart';
import '../../../../../core/extensions/address_extension.dart';
import '../../../../../core/extensions/payment_terms_extension.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/entities/order.dart';
import '../../../../../domain/entities/order_item.dart';
import '../../../../widgets/app_skeleton.dart';
import '../../../../widgets/buyer_supplier_card.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/order_status_badge.dart';
import '../order_detail_state.dart';

class OrderDetailContent extends StatelessWidget {
  const OrderDetailContent({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onSellerTap,
  });

  final OrderDetailState state;
  final VoidCallback onRetry;
  final VoidCallback onSellerTap;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    if (state.loading && order == null) {
      return const _OrderDetailSkeleton();
    }
    if (order == null) {
      return _OrderDetailError(
        message: state.errorMessage ?? 'Order details could not be loaded.',
        onRetry: onRetry,
      );
    }
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        _OrderHeading(order: order),
        const SizedBox(height: AppSpacing.lg),
        _OrderTimeline(order: order),
        const SizedBox(height: AppSpacing.md),
        _OrderPriceSummary(order: order),
        const SizedBox(height: AppSpacing.md),
        BuyerSupplierCard(supplier: order.seller, onTap: onSellerTap),
        const SizedBox(height: AppSpacing.md),
        _OrderItems(items: order.items),
        const SizedBox(height: AppSpacing.md),
        _OrderInformation(order: order),
      ],
    );
  }
}

class _OrderHeading extends StatelessWidget {
  const _OrderHeading({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            'Submitted ${DateFormat('d MMMM yyyy').format(order.placedAt)} · '
            '${order.seller.market.name}',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorTheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        OrderStatusBadge(status: order.status),
      ],
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final steps = _steps(order);
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order status',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (var index = 0; index < steps.length; index++)
            _TimelineStep(
              step: steps[index],
              showConnector: index != steps.length - 1,
              isCurrent: index == steps.length - 1,
            ),
        ],
      ),
    );
  }

  List<_OrderStep> _steps(Order order) {
    final steps = <_OrderStep>[
      _OrderStep(
        label: 'Submitted',
        status: OrderStatus.pending,
        date: order.placedAt,
      ),
    ];
    for (final event in order.timeline) {
      if (event.toStatus == OrderStatus.pending) continue;
      steps.add(
        _OrderStep(
          label: event.toStatus.displayText,
          status: event.toStatus,
          date: event.createdAt,
        ),
      );
    }
    if (steps.last.status != order.status) {
      steps.add(
        _OrderStep(
          label: order.status.displayText,
          status: order.status,
          date: order.updatedAt,
        ),
      );
    }
    return steps;
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.step,
    required this.showConnector,
    required this.isCurrent,
  });

  final _OrderStep step;
  final bool showConnector;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final color = step.status.foregroundColor(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 12,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                if (showConnector)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: color.withValues(alpha: 0.28),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.label,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    isCurrent &&
                            step.status != OrderStatus.delivered &&
                            step.status != OrderStatus.cancelled &&
                            step.status != OrderStatus.rejected
                        ? 'In progress · '
                              '${DateFormat('d MMM, h:mm a').format(step.date)}'
                        : DateFormat('d MMM, h:mm a').format(step.date),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStep {
  const _OrderStep({
    required this.label,
    required this.status,
    required this.date,
  });

  final String label;
  final OrderStatus status;
  final DateTime date;
}

class _OrderItems extends StatelessWidget {
  const _OrderItems({required this.items});

  final List<OrderItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: AppRadius.field,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items and ordered prices',
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (items.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No order lines were returned.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorTheme.onSurfaceVariant,
              ),
            ),
          ] else
            for (var index = 0; index < items.length; index++) ...[
              const SizedBox(height: AppSpacing.md),
              _OrderItemRow(item: items[index]),
              if (index != items.length - 1)
                const Divider(height: AppSpacing.lg),
            ],
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final OrderItem item;

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
                item.productName,
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${item.quantity} ${item.unit}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          item.lineTotal.formatted,
          style: context.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _OrderPriceSummary extends StatelessWidget {
  const _OrderPriceSummary({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final discount = double.tryParse(order.discountTotal?.amount ?? '0') ?? 0;
    final hasBreakdown =
        order.subtotal != null ||
        order.deliveryFee != null ||
        order.taxTotal != null ||
        discount > 0;
    return Container(
      width: double.infinity,
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: context.colorTheme.primaryContainer,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: context.colorTheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order total',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorTheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            order.total.formatted,
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorTheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (hasBreakdown) ...[
            const SizedBox(height: AppSpacing.md),
            Divider(
              height: 1,
              color: context.colorTheme.primary.withValues(alpha: 0.16),
            ),
            const SizedBox(height: AppSpacing.md),
            if (order.subtotal != null)
              _PriceRow(label: 'Subtotal', value: order.subtotal!.formatted),
            if (discount > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              _PriceRow(
                label: 'Discount',
                value: '−${order.discountTotal!.formatted}',
              ),
            ],
            if (order.deliveryFee != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _PriceRow(label: 'Delivery', value: order.deliveryFee!.formatted),
            ],
            if (order.taxTotal != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _PriceRow(label: 'Tax', value: order.taxTotal!.formatted),
            ],
          ],
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorTheme.onPrimaryContainer,
            ),
          ),
        ),
        Text(
          value,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorTheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _OrderInformation extends StatelessWidget {
  const _OrderInformation({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final address = order.deliveryAddress;
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
          Text(
            'Order information',
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (order.paymentTerms != null) ...[
            const SizedBox(height: AppSpacing.md),
            _InformationRow(
              label: 'Payment terms',
              value: order.paymentTerms!.label,
            ),
          ],
          if (address != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InformationRow(label: 'Delivery', value: address.displayAddress),
          ],
          if (order.notes != null && order.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _InformationRow(label: 'Notes', value: order.notes!),
          ],
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorTheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderDetailSkeleton extends StatelessWidget {
  const _OrderDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        AppSkeletonBox(height: 26),
        SizedBox(height: AppSpacing.lg),
        AppSkeletonBox(height: 222),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 148),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 88),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 156),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 132),
      ],
    );
  }
}

class _OrderDetailError extends StatelessWidget {
  const _OrderDetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      children: [
        const SizedBox(height: 100),
        Icon(
          Icons.error_outline_rounded,
          size: 44,
          color: context.colorTheme.error,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: CustomButton(
            text: 'Retry',
            width: 150,
            height: 48,
            onTap: onRetry,
          ),
        ),
      ],
    );
  }
}
