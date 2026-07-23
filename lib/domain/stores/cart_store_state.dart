import 'package:equatable/equatable.dart';

import '../entities/cart_item.dart';
import '../entities/organization.dart';

class CartStoreState extends Equatable {
  const CartStoreState({required this.items});

  const CartStoreState.initial() : items = const [];

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;
  Organization? get seller => items.firstOrNull?.product.seller;
  int get productLineCount => items.length;
  int get itemCount => items.fold(0, (total, item) => total + item.quantity);
  double get subtotal => items.fold(0, (total, item) => total + item.lineTotal);
  String? get currency => items.firstOrNull?.product.price.currency;

  CartStoreState copyWith({List<CartItem>? items}) {
    return CartStoreState(items: List.unmodifiable(items ?? this.items));
  }

  @override
  List<Object?> get props => [items];
}
