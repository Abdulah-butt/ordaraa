import 'package:equatable/equatable.dart';

import '../../../../domain/entities/order.dart';

class OrderDetailState extends Equatable {
  const OrderDetailState({
    required this.order,
    required this.loading,
    required this.errorMessage,
  });

  final Order? order;
  final bool loading;
  final String? errorMessage;

  factory OrderDetailState.initial() =>
      const OrderDetailState(order: null, loading: false, errorMessage: null);

  OrderDetailState copyWith({
    Order? Function()? order,
    bool? loading,
    String? Function()? errorMessage,
  }) {
    return OrderDetailState(
      order: order == null ? this.order : order(),
      loading: loading ?? this.loading,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }

  @override
  List<Object?> get props => [order, loading, errorMessage];
}
