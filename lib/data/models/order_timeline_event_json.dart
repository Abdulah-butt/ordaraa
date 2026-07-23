import '../../core/enums/order_status.dart';
import '../../domain/entities/order_timeline_event.dart';

class OrderTimelineEventJson {
  const OrderTimelineEventJson({
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

  factory OrderTimelineEventJson.fromJson(Map<String, dynamic> json) {
    final fromStatus = json['fromStatus'] as String?;
    return OrderTimelineEventJson(
      id: json['id'] as String,
      fromStatus: fromStatus == null
          ? null
          : OrderStatus.fromApiValue(fromStatus),
      toStatus: OrderStatus.fromApiValue(json['toStatus'] as String),
      reasonCode: json['reasonCode'] as String?,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  OrderTimelineEvent toDomain() => OrderTimelineEvent(
    id: id,
    fromStatus: fromStatus,
    toStatus: toStatus,
    reasonCode: reasonCode,
    note: note,
    createdAt: createdAt,
  );
}
