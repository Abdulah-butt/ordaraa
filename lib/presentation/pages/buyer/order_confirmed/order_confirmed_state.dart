import 'package:equatable/equatable.dart';

import '../../../../domain/entities/order.dart';

class OrderConfirmedState extends Equatable {
  const OrderConfirmedState({
    required this.order,
    required this.loading,
    required this.errorMessage,
  });

  factory OrderConfirmedState.initial() => const OrderConfirmedState(
    order: null,
    loading: false,
    errorMessage: null,
  );

  final Order? order;
  final bool loading;
  final String? errorMessage;

  OrderConfirmedState copyWith({
    Order? Function()? order,
    bool? loading,
    String? Function()? errorMessage,
  }) {
    return OrderConfirmedState(
      order: order == null ? this.order : order(),
      loading: loading ?? this.loading,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }

  @override
  List<Object?> get props => [order, loading, errorMessage];
}
