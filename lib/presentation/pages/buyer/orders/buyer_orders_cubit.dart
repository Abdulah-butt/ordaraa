import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/order_list_role.dart';
import '../../../../core/enums/order_list_status.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/usecases/get_orders_use_case.dart';
import '../../../../network/request_model/order_listing_request.dart';
import 'buyer_orders_initial_params.dart';
import 'buyer_orders_navigator.dart';
import 'buyer_orders_state.dart';

class BuyerOrdersCubit extends Cubit<BuyerOrdersState> {
  BuyerOrdersCubit({required this.navigator, required this.getOrdersUseCase})
    : super(BuyerOrdersState.initial());

  static const _limit = 20;

  final BuyerOrdersNavigator navigator;
  final GetOrdersUseCase getOrdersUseCase;
  final scrollController = ScrollController();
  bool _initialized = false;
  int _requestGeneration = 0;

  void onInit(BuyerOrdersInitialParams initialParams) {
    scrollController
      ..removeListener(_onScroll)
      ..addListener(_onScroll);
    if (_initialized) return;
    _initialized = true;
    unawaited(_loadFirstPage(refreshing: false));
  }

  Future<void> selectStatus(OrderListStatus status) async {
    if (status == state.selectedStatus) return;
    emit(state.copyWith(selectedStatus: status));
    _resetScroll();
    await _loadFirstPage(refreshing: false);
  }

  Future<void> selectRole(OrderListRole role) async {
    if (role == state.role) return;
    emit(state.copyWith(role: role));
    _resetScroll();
    await _loadFirstPage(refreshing: false);
  }

  void openOrder(String orderId) {
    navigator.openOrder(orderId);
  }

  Future<void> refresh() => _loadFirstPage(refreshing: true);

  Future<void> retryInitial() => _loadFirstPage(refreshing: false);

  Future<void> _loadFirstPage({required bool refreshing}) async {
    final generation = ++_requestGeneration;
    final role = state.role;
    final status = state.selectedStatus;
    emit(
      state.copyWith(
        orders: const [],
        initialLoading: !refreshing,
        refreshing: refreshing,
        loadingMore: false,
        nextCursor: () => null,
        hasNextPage: false,
        totalCount: 0,
        initialErrorMessage: () => null,
        loadMoreErrorMessage: () => null,
      ),
    );
    try {
      final result = await getOrdersUseCase.execute(
        request: OrderListingRequest(limit: _limit, role: role, status: status),
      );
      if (!_isCurrent(generation, role, status)) return;
      emit(
        state.copyWith(
          orders: _deduplicate(result.items),
          nextCursor: () => result.nextCursor,
          hasNextPage: result.hasNextPage,
          totalCount: result.totalCount ?? result.items.length,
        ),
      );
    } catch (error) {
      if (!_isCurrent(generation, role, status)) return;
      emit(state.copyWith(initialErrorMessage: () => error.toString()));
    } finally {
      if (_isCurrent(generation, role, status)) {
        emit(state.copyWith(initialLoading: false, refreshing: false));
      }
    }
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (!state.canLoadMore || cursor == null) return;
    final generation = _requestGeneration;
    final role = state.role;
    final status = state.selectedStatus;
    emit(state.copyWith(loadingMore: true, loadMoreErrorMessage: () => null));
    try {
      final result = await getOrdersUseCase.execute(
        request: OrderListingRequest(
          limit: _limit,
          cursor: cursor,
          role: role,
          status: status,
        ),
      );
      if (!_isCurrent(generation, role, status)) return;
      emit(
        state.copyWith(
          orders: _deduplicate([...state.orders, ...result.items]),
          nextCursor: () => result.nextCursor,
          hasNextPage: result.hasNextPage,
        ),
      );
    } catch (error) {
      if (!_isCurrent(generation, role, status)) return;
      emit(state.copyWith(loadMoreErrorMessage: () => error.toString()));
    } finally {
      if (_isCurrent(generation, role, status)) {
        emit(state.copyWith(loadingMore: false));
      }
    }
  }

  bool _isCurrent(int generation, OrderListRole role, OrderListStatus status) {
    return generation == _requestGeneration &&
        role == state.role &&
        status == state.selectedStatus;
  }

  List<Order> _deduplicate(List<Order> orders) {
    final byId = <String, Order>{};
    for (final order in orders) {
      byId.putIfAbsent(order.id, () => order);
    }
    return byId.values.toList(growable: false);
  }

  void _resetScroll() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < 240) {
      unawaited(loadMore());
    }
  }
}
