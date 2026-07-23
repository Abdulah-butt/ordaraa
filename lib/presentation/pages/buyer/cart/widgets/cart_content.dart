import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../domain/entities/cart_item.dart';
import '../../../../widgets/custom_button.dart';
import '../cart_state.dart';
import 'cart_item_card.dart';
import 'cart_summary.dart';

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
    required this.state,
    required this.onBack,
    required this.onBrowse,
    required this.onClear,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onProductTap,
    required this.onSellerTap,
    required this.onCheckout,
  });

  final CartState state;
  final VoidCallback onBack;
  final VoidCallback onBrowse;
  final VoidCallback onClear;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onProductTap;
  final ValueChanged<String> onSellerTap;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final cart = state.cart;
    return SafeArea(
      child: Column(
        children: [
          _CartAppBar(
            productLines: cart.productLineCount,
            sellerCount: cart.isEmpty ? 0 : 1,
            onBack: onBack,
            onClear: cart.isEmpty ? null : onClear,
          ),
          Expanded(
            child: cart.isEmpty
                ? _EmptyCart(onBrowse: onBrowse)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    children: [
                      _SupplierBanner(
                        name: cart.seller!.name,
                        verified: cart.seller!.verified,
                        onTap: () => onSellerTap(cart.seller!.id),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (final CartItem item in cart.items) ...[
                        CartItemCard(
                          item: item,
                          onTap: () => onProductTap(item.product.id),
                          onIncrement: () => onIncrement(item.product.id),
                          onDecrement: () => onDecrement(item.product.id),
                          onRemove: () => onRemove(item.product.id),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      CartSummary(cart: cart),
                      const SizedBox(height: AppSpacing.md),
                      _CheckoutNotice(),
                    ],
                  ),
          ),
          if (!cart.isEmpty)
            _CheckoutBar(
              total: _formatMoney(cart.subtotal, cart.currency),
              onCheckout: onCheckout,
            ),
        ],
      ),
    );
  }

  String _formatMoney(double amount, String? currency) {
    return NumberFormat.simpleCurrency(name: currency ?? 'AUD').format(amount);
  }
}

class _CartAppBar extends StatelessWidget {
  const _CartAppBar({
    required this.productLines,
    required this.sellerCount,
    required this.onBack,
    required this.onClear,
  });

  final int productLines;
  final int sellerCount;
  final VoidCallback onBack;
  final VoidCallback? onClear;

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
          _SquareAction(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cart',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (productLines > 0)
                  Text(
                    '$sellerCount supplier · $productLines product '
                    '${productLines == 1 ? 'line' : 'lines'}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              child: Text(
                'Clear',
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorTheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SquareAction extends StatelessWidget {
  const _SquareAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.field,
        side: BorderSide(color: context.colorTheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.field,
        child: SizedBox.square(
          dimension: AppSizes.controlSmall,
          child: Icon(icon, size: AppSizes.iconSm),
        ),
      ),
    );
  }
}

class _SupplierBanner extends StatelessWidget {
  const _SupplierBanner({
    required this.name,
    required this.verified,
    required this.onTap,
  });

  final String name;
  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorTheme.primaryContainer,
      borderRadius: AppRadius.field,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.field,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.storefront_outlined,
                color: context.colorTheme.primary,
                size: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '$name${verified ? ' · Verified' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'View',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        Container(
          height: 258,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colorTheme.surfaceContainerLow,
            borderRadius: AppRadius.dialog,
          ),
          child: Container(
            width: 142,
            height: 142,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorTheme.primaryContainer,
            ),
            child: SvgPicture.asset(
              Assets.buyerHomeCart,
              width: 76,
              height: 76,
              colorFilter: ColorFilter.mode(
                context.colorTheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Center(
          child: Text(
            'Your cart is empty',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Text(
            'Browse products available for your delivery address and add '
            'wholesale quantities to begin an order.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        CustomButton(
          text: 'Browse marketplace',
          height: AppSizes.buttonHeight,
          borderRadius: AppRadius.button,
          onTap: onBrowse,
        ),
      ],
    );
  }
}

class _CheckoutNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorTheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: AppRadius.field,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: AppSizes.iconSm,
            color: context.colorTheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Delivery charges, taxes, and supplier terms are confirmed '
              'before you place the order.',
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

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total, required this.onCheckout});

  final String total;
  final VoidCallback onCheckout;

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
                text: 'Continue to checkout · $total',
                height: 52,
                borderRadius: AppRadius.button,
                onTap: onCheckout,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Final total is confirmed at checkout',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
