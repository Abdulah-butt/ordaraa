import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/stores/cart_store.dart';
import '../../../../domain/stores/cart_store_state.dart';
import 'cart_initial_params.dart';
import 'cart_navigator.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required this.navigator,
    required this.cartStore,
    required this.snackBar,
  }) : super(CartState(cart: cartStore.state)) {
    _subscription = cartStore.stream.listen(_onCartChanged);
  }

  final CartNavigator navigator;
  final CartStore cartStore;
  final AppSnackBar snackBar;
  late final StreamSubscription<CartStoreState> _subscription;

  void onInit(CartInitialParams initialParams) {
    emit(state.copyWith(cart: cartStore.state));
  }

  void increment(String productId) => cartStore.increment(productId);

  void decrement(String productId) => cartStore.decrement(productId);

  void remove(String productId) {
    cartStore.remove(productId);
    snackBar.info('Product removed from cart.');
  }

  void clearCart() => navigator.confirmClear(() {
    cartStore.clear();
    snackBar.success('Cart cleared.');
  });

  void checkout() {
    snackBar.info('Checkout will be connected to order pricing next.');
  }

  void _onCartChanged(CartStoreState cart) {
    if (!isClosed) emit(state.copyWith(cart: cart));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
