import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/utils/assets.dart';
import '../../../../domain/entities/address.dart';
import '../../../../domain/entities/organization.dart';
import '../../../../domain/entities/product.dart';
import '../../../widgets/app_pull_to_refresh.dart';
import '../../../widgets/app_skeleton.dart';
import '../../../widgets/buyer_detail_app_bar.dart';
import '../../../widgets/buyer_product_card.dart';
import '../../../widgets/custom_cache_image.dart';
import 'seller_detail_cubit.dart';
import 'seller_detail_initial_params.dart';
import 'seller_detail_state.dart';

class SellerDetailPage extends StatefulWidget {
  const SellerDetailPage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/seller-detail';

  final SellerDetailCubit cubit;
  final SellerDetailInitialParams initialParams;

  @override
  State<SellerDetailPage> createState() => _SellerDetailPageState();
}

class _SellerDetailPageState extends State<SellerDetailPage> {
  SellerDetailCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerDetailCubit, SellerDetailState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                BuyerDetailAppBar(
                  title: 'Supplier',
                  onBack: cubit.navigator.goBack,
                  onCart: cubit.openCart,
                ),
                Expanded(
                  child: AppPullToRefresh(
                    onRefresh: cubit.refresh,
                    child: CustomScrollView(
                      controller: cubit.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                          sliver: SliverToBoxAdapter(
                            child: _SellerDetailBody(
                              state: state,
                              onRetry: cubit.retry,
                              onProductTap: cubit.openProduct,
                              onProductAdd: cubit.addProduct,
                              onEmailTap: cubit.contactByEmail,
                              onWhatsAppTap: cubit.contactByWhatsApp,
                              onContactTap: cubit.contactSeller,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SellerDetailBody extends StatelessWidget {
  const _SellerDetailBody({
    required this.state,
    required this.onRetry,
    required this.onProductTap,
    required this.onProductAdd,
    required this.onEmailTap,
    required this.onWhatsAppTap,
    required this.onContactTap,
  });

  final SellerDetailState state;
  final VoidCallback onRetry;
  final ValueChanged<String> onProductTap;
  final ValueChanged<Product> onProductAdd;
  final VoidCallback onEmailTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    final detail = state.detail;
    if (state.loading && detail == null) {
      return const _SellerDetailSkeleton();
    }
    if (detail == null) {
      return _SellerError(
        message: state.errorMessage ?? 'Supplier could not be loaded.',
        onRetry: onRetry,
      );
    }

    final seller = detail;
    final address =
        seller.addresses.where((address) => address.isDefault).firstOrNull ??
        seller.addresses.firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SellerHero(seller: seller, products: state.products),
        const SizedBox(height: 10),
        Row(
          children: [
            SvgPicture.asset(
              Assets.buyerHomeSupplierStore,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                seller.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (seller.verified) const _VerifiedBadge(),
          ],
        ),
        if (address != null) ...[
          const SizedBox(height: 6),
          Text(
            _formatAddress(address),
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SellerInfoTile(
                icon: Icons.public_outlined,
                label: 'Market',
                value: seller.market.name,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SellerInfoTile(
                icon: Icons.receipt_long_outlined,
                label: 'Terms',
                value:
                    seller.defaultPaymentTerms?.apiValue.replaceAll('_', ' ') ??
                    'Contact seller',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SellerInfoTile(
                icon: Icons.payments_outlined,
                label: 'Currency',
                value: seller.market.currency,
              ),
            ),
          ],
        ),
        if (seller.contactEmail != null || seller.contactPhone != null) ...[
          const SizedBox(height: 10),
          _SellerContactCard(
            email: seller.contactEmail,
            phone: seller.contactPhone,
            onEmailTap: onEmailTap,
            onWhatsAppTap: onWhatsAppTap,
            onContactTap: onContactTap,
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.colorTheme.primaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'All products',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${state.totalCount} products',
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (state.products.isEmpty)
          const SizedBox(
            height: 120,
            child: Center(child: Text('No active products available')),
          )
        else
          for (var index = 0; index < state.products.length; index++) ...[
            BuyerProductCard(
              product: state.products[index],
              layout: BuyerProductCardLayout.detailed,
              onTap: () => onProductTap(state.products[index].id),
              onAdd: () => onProductAdd(state.products[index]),
            ),
            if (index != state.products.length - 1) const SizedBox(height: 10),
          ],
        if (state.loadingMore) ...[
          const SizedBox(height: 10),
          const AppSkeleton(child: ProductCardSkeleton(detailed: true)),
        ],
      ],
    );
  }

  String _formatAddress(Address address) {
    return [
      address.line1,
      if (address.line2 != null) address.line2!,
      address.city,
      if (address.state != null) address.state!,
      if (address.postalCode != null) address.postalCode!,
    ].join(', ');
  }
}

class _SellerHero extends StatelessWidget {
  const _SellerHero({required this.seller, required this.products});
  final Organization seller;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final logo = seller.logo?.thumbnailUrl ?? seller.logo?.url;
    final productImages = products
        .map(
          (product) =>
              product.images.firstOrNull?.thumbnailUrl ??
              product.images.firstOrNull?.url,
        )
        .whereType<String>()
        .take(3)
        .toList(growable: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 118,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorTheme.primaryContainer,
          gradient: LinearGradient(
            colors: [
              context.colorTheme.primaryContainer,
              context.colorTheme.surfaceContainerLow,
            ],
          ),
        ),
        child: productImages.isNotEmpty
            ? Row(
                children: [
                  for (
                    var index = 0;
                    index < productImages.length;
                    index++
                  ) ...[
                    Expanded(
                      child: CustomCacheImage(
                        imgUrl: productImages[index],
                        height: 118,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (index != productImages.length - 1)
                      const SizedBox(width: 3),
                  ],
                ],
              )
            : logo == null
            ? Center(
                child: SvgPicture.asset(
                  Assets.buyerHomeSupplierStore,
                  width: 42,
                  height: 42,
                ),
              )
            : CustomCacheImage(
                imgUrl: logo,
                width: double.infinity,
                height: 118,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: context.ordaraColors.successContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '✓ Verified',
        style: context.textTheme.labelSmall?.copyWith(
          color: context.ordaraColors.success,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SellerInfoTile extends StatelessWidget {
  const _SellerInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: context.colorTheme.primaryContainer.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: context.colorTheme.primary),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorTheme.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerContactCard extends StatelessWidget {
  const _SellerContactCard({
    required this.email,
    required this.phone,
    required this.onEmailTap,
    required this.onWhatsAppTap,
    required this.onContactTap,
  });

  final String? email;
  final String? phone;
  final VoidCallback onEmailTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    final hasPhone = phone != null && phone!.trim().isNotEmpty;
    final hasEmail = email != null && email!.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          if (hasPhone)
            _ContactRow(
              icon: Icons.chat_outlined,
              label: 'WhatsApp',
              value: phone!,
              onTap: onWhatsAppTap,
            ),
          if (hasPhone && hasEmail) const SizedBox(height: 8),
          if (hasEmail)
            _ContactRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: email!,
              onTap: onEmailTap,
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton.icon(
              onPressed: onContactTap,
              icon: Icon(
                hasPhone ? Icons.chat_outlined : Icons.email_outlined,
                size: 18,
              ),
              label: const Text('Contact supplier'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorTheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          child: Row(
            children: [
              Icon(icon, size: 18, color: context.colorTheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 15,
                color: context.colorTheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SellerDetailSkeleton extends StatelessWidget {
  const _SellerDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AppSkeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: double.infinity, height: 118, uniRadius: 16),
          SizedBox(height: 12),
          Bone(width: 260, height: 26, uniRadius: 7),
          SizedBox(height: 9),
          Bone(width: 300, height: 13, uniRadius: 5),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Bone(height: 70, uniRadius: 14)),
              SizedBox(width: 8),
              Expanded(child: Bone(height: 70, uniRadius: 14)),
              SizedBox(width: 8),
              Expanded(child: Bone(height: 70, uniRadius: 14)),
            ],
          ),
          SizedBox(height: 14),
          ProductCardSkeleton(detailed: true),
          SizedBox(height: 10),
          ProductCardSkeleton(detailed: true),
        ],
      ),
    );
  }
}

class _SellerError extends StatelessWidget {
  const _SellerError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront_outlined,
              color: context.colorTheme.onSurfaceVariant,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
