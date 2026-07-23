import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/address_extension.dart';
import '../../../../../core/extensions/payment_terms_extension.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../widgets/app_skeleton.dart';
import '../../../../widgets/custom_button.dart';
import '../order_confirmed_state.dart';

class OrderConfirmedContent extends StatelessWidget {
  const OrderConfirmedContent({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onViewOrder,
    required this.onContinueShopping,
  });

  final OrderConfirmedState state;
  final VoidCallback onRetry;
  final VoidCallback onViewOrder;
  final VoidCallback onContinueShopping;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    if (state.loading && order == null) {
      return const SafeArea(child: _ConfirmationSkeleton());
    }
    if (order == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 44,
                  color: context.colorTheme.error,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  state.errorMessage ?? 'Order could not be loaded.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomButton(
                  text: 'Retry',
                  width: 160,
                  height: AppSizes.buttonHeight,
                  onTap: onRetry,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.massive,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        child: Column(
          children: [
            _SuccessMark(animate: !reducedMotion),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Order submitted',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              order.publicNumber,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorTheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: context.ordaraColors.warningContainer,
                borderRadius: AppRadius.card,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: AppSizes.iconXs,
                    color: context.ordaraColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    order.status.displayText,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.ordaraColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _OrderConfirmationSummary(state: state),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.ordaraColors.infoContainer,
                borderRadius: AppRadius.field,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    color: context.ordaraColors.info,
                    size: AppSizes.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'The supplier will confirm product availability and '
                      'provide fulfilment updates.',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.ordaraColors.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomButton(
              text: 'View orders',
              height: 52,
              borderRadius: AppRadius.button,
              onTap: onViewOrder,
            ),
            const SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: 'Continue shopping',
              height: 44,
              borderRadius: BorderRadius.circular(10),
              isSecondary: true,
              borderSide: BorderSide(color: context.colorTheme.primary),
              foregroundColor: context.colorTheme.primary,
              onTap: onContinueShopping,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'You can track status changes from your Orders tab.',
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorTheme.onSurfaceVariant,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessMark extends StatelessWidget {
  const _SuccessMark({required this.animate});

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.ordaraColors.successContainer,
      ),
      child: Icon(
        Icons.check_rounded,
        color: context.ordaraColors.success,
        size: 34,
      ),
    );
    if (!animate) return mark;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.72, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: mark,
    );
  }
}

class _OrderConfirmationSummary extends StatelessWidget {
  const _OrderConfirmationSummary({required this.state});

  final OrderConfirmedState state;

  @override
  Widget build(BuildContext context) {
    final order = state.order!;
    final deliveryAddress = order.deliveryAddress;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.seller.name,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${order.items.length} '
                '${order.items.length == 1 ? 'line' : 'lines'}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(label: 'Order total', value: order.total.formatted),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: 'Placed',
            value: DateFormat('d MMM yyyy, h:mm a').format(order.placedAt),
          ),
          if (deliveryAddress != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: 'Delivery address',
              value: deliveryAddress.shortAddress,
            ),
          ],
          if (order.paymentTerms != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: 'Payment terms',
              value: order.paymentTerms!.label,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorTheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: context.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmationSkeleton extends StatelessWidget {
  const _ConfirmationSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.xxxl),
          AppSkeletonBox(width: 92, height: 92),
          SizedBox(height: AppSpacing.lg),
          AppSkeletonBox(width: 210, height: 34),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(width: 100, height: 20),
          SizedBox(height: AppSpacing.xxl),
          AppSkeletonBox(height: 180),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 62),
        ],
      ),
    );
  }
}
