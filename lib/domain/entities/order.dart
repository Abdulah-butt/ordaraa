import 'package:equatable/equatable.dart';

import '../../core/enums/order_status.dart';
import '../../core/enums/payment_terms.dart';
import 'address.dart';
import 'money.dart';
import 'order_item.dart';
import 'order_placed_by.dart';
import 'order_timeline_event.dart';
import 'organization.dart';

class Order extends Equatable {
  Order({
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
    List<OrderItem> items = const [],
    List<OrderTimelineEvent> timeline = const [],
  }) : items = List.unmodifiable(items),
       timeline = List.unmodifiable(timeline);

  final String id;
  final String publicNumber;
  final Organization buyer;
  final Organization seller;
  final OrderStatus status;
  final Money total;
  final DateTime placedAt;
  final DateTime updatedAt;
  final OrderPlacedBy? placedBy;
  final Money? subtotal;
  final Money? taxTotal;
  final Money? deliveryFee;
  final Money? discountTotal;
  final Address? deliveryAddress;
  final Address? billingAddress;
  final PaymentTerms? paymentTerms;
  final String? notes;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final List<OrderItem> items;
  final List<OrderTimelineEvent> timeline;

  Order copyWith({
    String? id,
    String? publicNumber,
    Organization? buyer,
    Organization? seller,
    OrderStatus? status,
    Money? total,
    DateTime? placedAt,
    DateTime? updatedAt,
    OrderPlacedBy? Function()? placedBy,
    Money? Function()? subtotal,
    Money? Function()? taxTotal,
    Money? Function()? deliveryFee,
    Money? Function()? discountTotal,
    Address? Function()? deliveryAddress,
    Address? Function()? billingAddress,
    PaymentTerms? Function()? paymentTerms,
    String? Function()? notes,
    DateTime? Function()? confirmedAt,
    DateTime? Function()? cancelledAt,
    List<OrderItem>? items,
    List<OrderTimelineEvent>? timeline,
  }) {
    return Order(
      id: id ?? this.id,
      publicNumber: publicNumber ?? this.publicNumber,
      buyer: buyer ?? this.buyer,
      seller: seller ?? this.seller,
      status: status ?? this.status,
      total: total ?? this.total,
      placedAt: placedAt ?? this.placedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      placedBy: placedBy == null ? this.placedBy : placedBy(),
      subtotal: subtotal == null ? this.subtotal : subtotal(),
      taxTotal: taxTotal == null ? this.taxTotal : taxTotal(),
      deliveryFee: deliveryFee == null ? this.deliveryFee : deliveryFee(),
      discountTotal: discountTotal == null
          ? this.discountTotal
          : discountTotal(),
      deliveryAddress: deliveryAddress == null
          ? this.deliveryAddress
          : deliveryAddress(),
      billingAddress: billingAddress == null
          ? this.billingAddress
          : billingAddress(),
      paymentTerms: paymentTerms == null ? this.paymentTerms : paymentTerms(),
      notes: notes == null ? this.notes : notes(),
      confirmedAt: confirmedAt == null ? this.confirmedAt : confirmedAt(),
      cancelledAt: cancelledAt == null ? this.cancelledAt : cancelledAt(),
      items: items ?? this.items,
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  List<Object?> get props => [
    id,
    publicNumber,
    buyer,
    seller,
    status,
    total,
    placedAt,
    updatedAt,
    placedBy,
    subtotal,
    taxTotal,
    deliveryFee,
    discountTotal,
    deliveryAddress,
    billingAddress,
    paymentTerms,
    notes,
    confirmedAt,
    cancelledAt,
    items,
    timeline,
  ];
}
