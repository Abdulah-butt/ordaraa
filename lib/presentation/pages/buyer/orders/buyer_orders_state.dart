import 'package:equatable/equatable.dart';

import '../../../../core/enums/order_list_role.dart';
import '../../../../core/enums/order_list_status.dart';
import '../../../../domain/entities/order.dart';

class BuyerOrdersState extends Equatable {
  const BuyerOrdersState({
    required this.selectedStatus,
    required this.role,
    required this.orders,
    required this.initialLoading,
    required this.refreshing,
    required this.loadingMore,
    required this.nextCursor,
    required this.hasNextPage,
    required this.totalCount,
    required this.initialErrorMessage,
    required this.loadMoreErrorMessage,
  });

  final OrderListStatus selectedStatus;
  final OrderListRole role;
  final List<Order> orders;
  final bool initialLoading;
  final bool refreshing;
  final bool loadingMore;
  final String? nextCursor;
  final bool hasNextPage;
  final int totalCount;
  final String? initialErrorMessage;
  final String? loadMoreErrorMessage;

  bool get canLoadMore =>
      hasNextPage &&
      nextCursor != null &&
      !initialLoading &&
      !refreshing &&
      !loadingMore;

  factory BuyerOrdersState.initial() => const BuyerOrdersState(
    selectedStatus: OrderListStatus.active,
    role: OrderListRole.buyer,
    orders: [],
    initialLoading: false,
    refreshing: false,
    loadingMore: false,
    nextCursor: null,
    hasNextPage: false,
    totalCount: 0,
    initialErrorMessage: null,
    loadMoreErrorMessage: null,
  );

  BuyerOrdersState copyWith({
    OrderListStatus? selectedStatus,
    OrderListRole? role,
    List<Order>? orders,
    bool? initialLoading,
    bool? refreshing,
    bool? loadingMore,
    String? Function()? nextCursor,
    bool? hasNextPage,
    int? totalCount,
    String? Function()? initialErrorMessage,
    String? Function()? loadMoreErrorMessage,
  }) {
    return BuyerOrdersState(
      selectedStatus: selectedStatus ?? this.selectedStatus,
      role: role ?? this.role,
      orders: orders ?? this.orders,
      initialLoading: initialLoading ?? this.initialLoading,
      refreshing: refreshing ?? this.refreshing,
      loadingMore: loadingMore ?? this.loadingMore,
      nextCursor: nextCursor == null ? this.nextCursor : nextCursor(),
      hasNextPage: hasNextPage ?? this.hasNextPage,
      totalCount: totalCount ?? this.totalCount,
      initialErrorMessage: initialErrorMessage == null
          ? this.initialErrorMessage
          : initialErrorMessage(),
      loadMoreErrorMessage: loadMoreErrorMessage == null
          ? this.loadMoreErrorMessage
          : loadMoreErrorMessage(),
    );
  }

  @override
  List<Object?> get props => [
    selectedStatus,
    role,
    orders,
    initialLoading,
    refreshing,
    loadingMore,
    nextCursor,
    hasNextPage,
    totalCount,
    initialErrorMessage,
    loadMoreErrorMessage,
  ];
}
