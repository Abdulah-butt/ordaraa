import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/extensions/theme_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/order.dart';
import 'order_status_badge.dart';

class BuyerOrderCard extends StatelessWidget {
  const BuyerOrderCard({super.key, required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(color: context.colorTheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Padding(
          padding: AppSpacing.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.publicNumber,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                order.seller.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${order.total.formatted} · Placed '
                '${DateFormat('d MMM yyyy').format(order.placedAt)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: AppSizes.iconXs,
                    color: context.colorTheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Updated ${DateFormat('d MMM, h:mm a').format(order.updatedAt)}',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    'View order',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: AppSizes.iconXs,
                    color: context.colorTheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
