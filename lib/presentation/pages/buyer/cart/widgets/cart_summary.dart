import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/stores/cart_store_state.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.cart});

  final CartStoreState cart;

  @override
  Widget build(BuildContext context) {
    final subtotal = NumberFormat.simpleCurrency(
      name: cart.currency ?? 'AUD',
    ).format(cart.subtotal);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        borderRadius: AppRadius.field,
        border: Border.all(color: context.colorTheme.outlineVariant),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: subtotal),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(label: 'Delivery', value: 'At checkout', muted: true),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(label: 'Taxes', value: 'At checkout', muted: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: 'Current total',
            value: subtotal,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.muted = false,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool muted;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final color = muted
        ? context.colorTheme.onSurfaceVariant
        : context.colorTheme.onSurface;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: context.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
