import 'package:equatable/equatable.dart';

import 'checkout_preview_item.dart';
import 'money.dart';

class CheckoutPreview extends Equatable {
  CheckoutPreview({
    required this.sellerOrganizationId,
    required this.currencyCode,
    required List<CheckoutPreviewItem> items,
    required this.subtotal,
    required this.taxTotal,
    required this.deliveryFee,
    required this.discountTotal,
    required this.total,
  }) : items = List.unmodifiable(items);

  final String sellerOrganizationId;
  final String currencyCode;
  final List<CheckoutPreviewItem> items;
  final Money subtotal;
  final Money taxTotal;
  final Money deliveryFee;
  final Money discountTotal;
  final Money total;

  CheckoutPreview copyWith({
    String? sellerOrganizationId,
    String? currencyCode,
    List<CheckoutPreviewItem>? items,
    Money? subtotal,
    Money? taxTotal,
    Money? deliveryFee,
    Money? discountTotal,
    Money? total,
  }) {
    return CheckoutPreview(
      sellerOrganizationId: sellerOrganizationId ?? this.sellerOrganizationId,
      currencyCode: currencyCode ?? this.currencyCode,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxTotal: taxTotal ?? this.taxTotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discountTotal: discountTotal ?? this.discountTotal,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
    sellerOrganizationId,
    currencyCode,
    items,
    subtotal,
    taxTotal,
    deliveryFee,
    discountTotal,
    total,
  ];
}
