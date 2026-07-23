import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/extensions/address_extension.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../domain/stores/cart_store_state.dart';
import '../../../../widgets/app_skeleton.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
import '../checkout_state.dart';
import 'checkout_order_summary.dart';

class CheckoutContent extends StatelessWidget {
  const CheckoutContent({
    super.key,
    required this.state,
    required this.cart,
    required this.notesController,
    required this.onBack,
    required this.onAddressTap,
    required this.onRetry,
    required this.onPlaceOrder,
  });

  final CheckoutState state;
  final CartStoreState cart;
  final TextEditingController notesController;
  final VoidCallback onBack;
  final VoidCallback onAddressTap;
  final VoidCallback onRetry;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final ready =
        state.selectedDeliveryAddress != null &&
        state.preview != null &&
        !state.previewing;
    return SafeArea(
      child: Column(
        children: [
          _CheckoutAppBar(onBack: onBack),
          Expanded(
            child: state.loading && state.addresses.isEmpty
                ? const _CheckoutSkeleton()
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xs,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.previewing)
                          const AppSkeletonBox(height: 38)
                        else if (ready)
                          const _ReadyBanner(),
                        if (state.previewing || ready)
                          const SizedBox(height: AppSpacing.md),
                        _DetailCard(
                          icon: Icons.location_on_outlined,
                          label: 'Delivery',
                          title:
                              state.selectedDeliveryAddress?.displayAddress ??
                              'No delivery address available',
                          description:
                              state.selectedDeliveryAddress?.contactName == null
                              ? 'Choose an organization address'
                              : 'Receiving contact: '
                                    '${state.selectedDeliveryAddress!.contactName}',
                          actionLabel: state.addresses.isEmpty
                              ? null
                              : 'Change',
                          onTap: state.addresses.isEmpty ? null : onAddressTap,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const _InvoiceInformation(),
                        const SizedBox(height: AppSpacing.lg),
                        CustomTextField(
                          controller: notesController,
                          label: 'Order notes (optional)',
                          hint: 'Delivery instructions or supplier note',
                          isDetail: true,
                          height: 76,
                          bottomPadding: 0,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1000),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        CheckoutOrderSummary(
                          cart: cart,
                          preview: state.preview,
                          previewing: state.previewing,
                        ),
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          _CheckoutError(
                            message: state.errorMessage!,
                            onRetry: onRetry,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        const _ConfirmationNote(),
                      ],
                    ),
                  ),
          ),
          _PlaceOrderBar(
            enabled: ready,
            placing: state.placingOrder,
            onPlaceOrder: onPlaceOrder,
          ),
        ],
      ),
    );
  }
}

class _CheckoutAppBar extends StatelessWidget {
  const _CheckoutAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Material(
            color: context.colorTheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.field,
              side: BorderSide(color: context.colorTheme.outlineVariant),
            ),
            child: InkWell(
              onTap: onBack,
              borderRadius: AppRadius.field,
              child: const SizedBox.square(
                dimension: AppSizes.controlSmall,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: AppSizes.iconSm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checkout',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Review pricing and delivery details',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadyBanner extends StatelessWidget {
  const _ReadyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.ordaraColors.successContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_rounded,
            color: context.ordaraColors.success,
            size: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Your checkout preview is ready.',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.ordaraColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.label,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        borderRadius: AppRadius.field,
        border: Border.all(color: context.colorTheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.colorTheme.primary, size: AppSizes.iconMd),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorTheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                minimumSize: const Size(44, 36),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

class _InvoiceInformation extends StatelessWidget {
  const _InvoiceInformation();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.ordaraColors.infoContainer,
        borderRadius: AppRadius.field,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: context.ordaraColors.info,
            size: AppSizes.iconMd,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoice and payment',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.ordaraColors.info,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Once the supplier confirms your order, they’ll issue an '
                  'invoice. We’ll notify you when it’s ready, and you can '
                  'review and pay it from Orders.',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutError extends StatelessWidget {
  const _CheckoutError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorTheme.errorContainer,
        borderRadius: AppRadius.field,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.colorTheme.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorTheme.onErrorContainer,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _ConfirmationNote extends StatelessWidget {
  const _ConfirmationNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.ordaraColors.warningContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'The supplier confirms product availability after submission.',
        style: context.textTheme.labelSmall?.copyWith(
          color: context.ordaraColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  const _PlaceOrderBar({
    required this.enabled,
    required this.placing,
    required this.onPlaceOrder,
  });

  final bool enabled;
  final bool placing;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border(
          top: BorderSide(color: context.colorTheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: 'Place order',
                height: 52,
                borderRadius: AppRadius.button,
                isDisabled: !enabled,
                isLoading: placing,
                onTap: onPlaceOrder,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'By placing the order, you confirm the quantities and terms.',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutSkeleton extends StatelessWidget {
  const _CheckoutSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: Column(
        children: [
          AppSkeletonBox(height: 38),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 108),
          SizedBox(height: AppSpacing.md),
          AppSkeletonBox(height: 104),
          SizedBox(height: AppSpacing.lg),
          AppSkeletonBox(height: 76),
          SizedBox(height: AppSpacing.lg),
          CheckoutOrderSummarySkeleton(),
        ],
      ),
    );
  }
}
