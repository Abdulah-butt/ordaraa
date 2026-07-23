import '../../core/enums/order_status.dart';
import '../../core/enums/payment_terms.dart';
import '../../domain/entities/order.dart';
import 'address_json.dart';
import 'money_json.dart';
import 'order_item_json.dart';
import 'order_placed_by_json.dart';
import 'order_timeline_event_json.dart';
import 'organization_json.dart';

class OrderJson {
  OrderJson({
    required this.id,
    required this.publicNumber,
    required this.buyer,
    required this.seller,
    required this.status,
    required this.total,
    required this.placedAt,
    required this.updatedAt,
    required this.placedBy,
    required this.subtotal,
    required this.taxTotal,
    required this.deliveryFee,
    required this.discountTotal,
    required this.deliveryAddress,
    required this.billingAddress,
    required this.paymentTerms,
    required this.notes,
    required this.confirmedAt,
    required this.cancelledAt,
    List<OrderItemJson> items = const [],
    List<OrderTimelineEventJson> timeline = const [],
  }) : items = List.unmodifiable(items),
       timeline = List.unmodifiable(timeline);

  final String id;
  final String publicNumber;
  final OrganizationJson buyer;
  final OrganizationJson seller;
  final OrderStatus status;
  final MoneyJson total;
  final DateTime placedAt;
  final DateTime updatedAt;
  final OrderPlacedByJson? placedBy;
  final MoneyJson? subtotal;
  final MoneyJson? taxTotal;
  final MoneyJson? deliveryFee;
  final MoneyJson? discountTotal;
  final AddressJson? deliveryAddress;
  final AddressJson? billingAddress;
  final PaymentTerms? paymentTerms;
  final String? notes;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final List<OrderItemJson> items;
  final List<OrderTimelineEventJson> timeline;

  factory OrderJson.fromJson(Map<String, dynamic> json) {
    final paymentTerms = json['paymentTerms'] as String?;
    return OrderJson(
      id: json['id'] as String,
      publicNumber: json['publicNumber'] as String,
      buyer: OrganizationJson.fromJson(json['buyer'] as Map<String, dynamic>),
      seller: OrganizationJson.fromJson(json['seller'] as Map<String, dynamic>),
      status: OrderStatus.fromApiValue(json['status'] as String),
      total: MoneyJson.fromJson(json['total'] as Map<String, dynamic>),
      placedAt: DateTime.parse(json['placedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      placedBy: _nullableMap(json['placedBy'], OrderPlacedByJson.fromJson),
      subtotal: _nullableMap(json['subtotal'], MoneyJson.fromJson),
      taxTotal: _nullableMap(json['taxTotal'], MoneyJson.fromJson),
      deliveryFee: _nullableMap(json['deliveryFee'], MoneyJson.fromJson),
      discountTotal: _nullableMap(json['discountTotal'], MoneyJson.fromJson),
      deliveryAddress: _nullableMap(
        json['deliveryAddress'],
        AddressJson.fromJson,
      ),
      billingAddress: _nullableMap(
        json['billingAddress'],
        AddressJson.fromJson,
      ),
      paymentTerms: paymentTerms == null
          ? null
          : PaymentTerms.fromApiValue(paymentTerms),
      notes: json['notes'] as String?,
      confirmedAt: _date(json['confirmedAt']),
      cancelledAt: _date(json['cancelledAt']),
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((item) => OrderItemJson.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      timeline: (json['timeline'] as List<dynamic>? ?? const [])
          .map(
            (event) =>
                OrderTimelineEventJson.fromJson(event as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }

  static T? _nullableMap<T>(
    dynamic value,
    T Function(Map<String, dynamic>) mapper,
  ) {
    return value is Map<String, dynamic> ? mapper(value) : null;
  }

  static DateTime? _date(dynamic value) {
    return value is String ? DateTime.parse(value) : null;
  }

  Order toDomain() => Order(
    id: id,
    publicNumber: publicNumber,
    buyer: buyer.toDomain(),
    seller: seller.toDomain(),
    status: status,
    total: total.toDomain(),
    placedAt: placedAt,
    updatedAt: updatedAt,
    placedBy: placedBy?.toDomain(),
    subtotal: subtotal?.toDomain(),
    taxTotal: taxTotal?.toDomain(),
    deliveryFee: deliveryFee?.toDomain(),
    discountTotal: discountTotal?.toDomain(),
    deliveryAddress: deliveryAddress?.toDomain(),
    billingAddress: billingAddress?.toDomain(),
    paymentTerms: paymentTerms,
    notes: notes,
    confirmedAt: confirmedAt,
    cancelledAt: cancelledAt,
    items: items.map((item) => item.toDomain()).toList(growable: false),
    timeline: timeline.map((event) => event.toDomain()).toList(growable: false),
  );
}
