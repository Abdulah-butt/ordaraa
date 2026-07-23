import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/cart_item.dart';
import '../entities/product.dart';
import 'cart_store_state.dart';

class CartStore extends Cubit<CartStoreState> {
  CartStore() : super(const CartStoreState.initial());

  void put(Product product, int quantity) {
    final index = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    final items = [...state.items];
    if (index == -1) {
      items.add(CartItem(product: product, quantity: quantity));
    } else {
      items[index] = items[index].copyWith(
        product: product,
        quantity: items[index].quantity + quantity,
      );
    }
    emit(state.copyWith(items: items));
  }

  void increment(String productId) {
    final item = _find(productId);
    if (item == null) return;
    final increment = _positiveQuantity(item.product.quantityIncrement);
    _replace(item.copyWith(quantity: item.quantity + increment));
  }

  void decrement(String productId) {
    final item = _find(productId);
    if (item == null) return;
    final minimum = _positiveQuantity(item.product.minimumOrderQuantity);
    final increment = _positiveQuantity(item.product.quantityIncrement);
    final nextQuantity = item.quantity - increment;
    if (nextQuantity < minimum) return;
    _replace(item.copyWith(quantity: nextQuantity));
  }

  void remove(String productId) {
    emit(
      state.copyWith(
        items: state.items
            .where((item) => item.product.id != productId)
            .toList(growable: false),
      ),
    );
  }

  void clear() => emit(const CartStoreState.initial());

  CartItem? _find(String productId) {
    return state.items
        .where((item) => item.product.id == productId)
        .firstOrNull;
  }

  void _replace(CartItem updated) {
    emit(
      state.copyWith(
        items: state.items
            .map(
              (item) => item.product.id == updated.product.id ? updated : item,
            )
            .toList(growable: false),
      ),
    );
  }

  int _positiveQuantity(String value) {
    final parsed = (num.tryParse(value) ?? 1).ceil();
    return parsed < 1 ? 1 : parsed;
  }
}
