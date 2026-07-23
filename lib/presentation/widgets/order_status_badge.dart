import 'package:flutter/material.dart';

import '../../core/enums/order_status.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor(context),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        status.displayText,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: status.foregroundColor(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
