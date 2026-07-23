import 'package:equatable/equatable.dart';

import '../../core/enums/order_status.dart';

class OrderTimelineEvent extends Equatable {
  const OrderTimelineEvent({
    required this.id,
    required this.fromStatus,
    required this.toStatus,
    required this.reasonCode,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final OrderStatus? fromStatus;
  final OrderStatus toStatus;
  final String? reasonCode;
  final String? note;
  final DateTime createdAt;

  OrderTimelineEvent copyWith({
    String? id,
    OrderStatus? Function()? fromStatus,
    OrderStatus? toStatus,
    String? Function()? reasonCode,
    String? Function()? note,
    DateTime? createdAt,
  }) {
    return OrderTimelineEvent(
      id: id ?? this.id,
      fromStatus: fromStatus == null ? this.fromStatus : fromStatus(),
      toStatus: toStatus ?? this.toStatus,
      reasonCode: reasonCode == null ? this.reasonCode : reasonCode(),
      note: note == null ? this.note : note(),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fromStatus,
    toStatus,
    reasonCode,
    note,
    createdAt,
  ];
}
