import 'package:equatable/equatable.dart';

import '../../../../domain/stores/cart_store_state.dart';

class CartState extends Equatable {
  const CartState({required this.cart});

  factory CartState.initial() =>
      const CartState(cart: CartStoreState.initial());

  final CartStoreState cart;

  CartState copyWith({CartStoreState? cart}) {
    return CartState(cart: cart ?? this.cart);
  }

  @override
  List<Object?> get props => [cart];
}
