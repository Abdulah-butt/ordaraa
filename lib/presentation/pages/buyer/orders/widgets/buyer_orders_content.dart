import 'package:flutter/material.dart';

import '../../../../../core/enums/order_list_status.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../widgets/app_pull_to_refresh.dart';
import '../../../../widgets/app_skeleton.dart';
import '../../../../widgets/buyer_order_card.dart';
import '../buyer_orders_state.dart';

class BuyerOrdersContent extends StatelessWidget {
  const BuyerOrdersContent({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onTabSelected,
    required this.onRefresh,
    required this.onRetry,
    required this.onLoadMoreRetry,
    required this.onOrderSelected,
  });

  final BuyerOrdersState state;
  final ScrollController scrollController;
  final ValueChanged<OrderListStatus> onTabSelected;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final VoidCallback onLoadMoreRetry;
  final ValueChanged<String> onOrderSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: _OrdersHeader(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _OrderTabs(
              selected: state.selectedStatus,
              onSelected: onTabSelected,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: AppPullToRefresh(
              onRefresh: onRefresh,
              child: _OrdersBody(
                state: state,
                controller: scrollController,
                onRetry: onRetry,
                onLoadMoreRetry: onLoadMoreRetry,
                onOrderSelected: onOrderSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Track fulfilment, invoices and payment status',
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({required this.selected, required this.onSelected});

  final OrderListStatus selected;
  final ValueChanged<OrderListStatus> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        borderRadius: AppRadius.field,
      ),
      child: Row(
        children: [
          for (final status in OrderListStatus.values)
            Expanded(
              child: _OrderTab(
                label: status.displayText,
                selected: selected == status,
                onTap: () => onSelected(status),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderTab extends StatelessWidget {
  const _OrderTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? context.colorTheme.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: selected
                    ? context.colorTheme.primary
                    : context.colorTheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrdersBody extends StatelessWidget {
  const _OrdersBody({
    required this.state,
    required this.controller,
    required this.onRetry,
    required this.onLoadMoreRetry,
    required this.onOrderSelected,
  });

  final BuyerOrdersState state;
  final ScrollController controller;
  final VoidCallback onRetry;
  final VoidCallback onLoadMoreRetry;
  final ValueChanged<String> onOrderSelected;

  @override
  Widget build(BuildContext context) {
    if ((state.initialLoading || state.refreshing) && state.orders.isEmpty) {
      return const _OrdersSkeleton();
    }
    if (state.initialErrorMessage != null && state.orders.isEmpty) {
      return _OrdersError(
        message: state.initialErrorMessage!,
        onRetry: onRetry,
      );
    }
    if (state.orders.isEmpty) {
      return _EmptyOrders(status: state.selectedStatus);
    }
    final showFooter = state.loadingMore || state.loadMoreErrorMessage != null;
    return ListView.separated(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      itemCount: state.orders.length + (showFooter ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == state.orders.length) {
          if (state.loadingMore) {
            return const AppSkeletonBox(height: 156);
          }
          return _LoadMoreError(
            message: state.loadMoreErrorMessage!,
            onRetry: onLoadMoreRetry,
          );
        }
        final order = state.orders[index];
        return BuyerOrderCard(
          order: order,
          onTap: () => onOrderSelected(order.id),
        );
      },
    );
  }
}

class _OrdersSkeleton extends StatelessWidget {
  const _OrdersSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: const [
        AppSkeletonBox(height: 156),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 156),
        SizedBox(height: AppSpacing.md),
        AppSkeletonBox(height: 156),
      ],
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.status});

  final OrderListStatus status;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      children: [
        const SizedBox(height: 100),
        Icon(
          Icons.receipt_long_outlined,
          size: 42,
          color: context.colorTheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'No ${status.displayText.toLowerCase()} orders',
          textAlign: TextAlign.center,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Pull down to check for the latest updates.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LoadMoreError extends StatelessWidget {
  const _LoadMoreError({required this.message, required this.onRetry});

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
          Icon(Icons.error_outline_rounded, color: context.colorTheme.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
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

class _OrdersError extends StatelessWidget {
  const _OrdersError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.xxl),
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.error_outline_rounded,
          size: 42,
          color: context.colorTheme.error,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Orders could not be loaded',
          textAlign: TextAlign.center,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ),
      ],
    );
  }
}
