import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/get_order_by_id_use_case.dart';
import 'order_confirmed_initial_params.dart';
import 'order_confirmed_navigator.dart';
import 'order_confirmed_state.dart';

class OrderConfirmedCubit extends Cubit<OrderConfirmedState> {
  OrderConfirmedCubit({
    required this.navigator,
    required this.getOrderByIdUseCase,
  }) : super(OrderConfirmedState.initial());

  final OrderConfirmedNavigator navigator;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  String? _orderId;

  Future<void> onInit(OrderConfirmedInitialParams initialParams) async {
    emit(OrderConfirmedState.initial());
    if (initialParams.orderId.isEmpty) {
      emit(state.copyWith(errorMessage: () => 'Order ID is missing.'));
      return;
    }
    _orderId = initialParams.orderId;
    await _load();
  }

  Future<void> retry() => _load();

  Future<void> _load() async {
    final orderId = _orderId;
    if (orderId == null || state.loading) return;
    emit(state.copyWith(loading: true, errorMessage: () => null));
    try {
      final order = await getOrderByIdUseCase.execute(id: orderId);
      emit(state.copyWith(order: () => order));
    } catch (error) {
      emit(state.copyWith(errorMessage: () => error.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}
