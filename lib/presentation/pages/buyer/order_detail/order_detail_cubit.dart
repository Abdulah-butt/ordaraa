import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/extensions/url_launcher_extension.dart';
import '../../../../domain/usecases/get_order_by_id_use_case.dart';
import 'order_detail_initial_params.dart';
import 'order_detail_navigator.dart';
import 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({
    required this.navigator,
    required this.getOrderByIdUseCase,
    required this.snackBar,
  }) : super(OrderDetailState.initial());

  final OrderDetailNavigator navigator;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final AppSnackBar snackBar;
  String? _orderId;

  Future<void> onInit(OrderDetailInitialParams initialParams) async {
    if (initialParams.orderId.isEmpty) {
      emit(state.copyWith(errorMessage: () => 'Order ID is missing.'));
      return;
    }
    if (_orderId == initialParams.orderId && state.order != null) return;
    _orderId = initialParams.orderId;
    await _load();
  }

  Future<void> refresh() => _load(preserveData: true);

  Future<void> retry() => _load();

  Future<void> _load({bool preserveData = false}) async {
    final orderId = _orderId;
    if (orderId == null || state.loading) return;
    emit(
      state.copyWith(
        order: preserveData ? null : () => null,
        loading: true,
        errorMessage: () => null,
      ),
    );
    try {
      final order = await getOrderByIdUseCase.execute(id: orderId);
      emit(state.copyWith(order: () => order));
    } catch (error) {
      emit(state.copyWith(errorMessage: () => error.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void openSeller() {
    final sellerId = state.order?.seller.id;
    if (sellerId != null) navigator.openSeller(sellerId);
  }

  Future<void> contactSeller() async {
    final seller = state.order?.seller;
    if (seller == null) return;
    try {
      final phone = seller.contactPhone;
      if (phone != null && phone.trim().isNotEmpty) {
        await phone.launchWhatsApp();
        return;
      }
      final email = seller.contactEmail;
      if (email != null && email.trim().isNotEmpty) {
        await email.launchEmail();
        return;
      }
      snackBar.error('This supplier has not provided contact details.');
    } catch (error) {
      snackBar.error(error.toString());
    }
  }
}
