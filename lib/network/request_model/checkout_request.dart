import 'package:equatable/equatable.dart';

import 'checkout_item_request.dart';

class CheckoutRequest extends Equatable {
  CheckoutRequest({
    required List<CheckoutItemRequest> items,
    required this.deliveryAddressId,
    this.billingAddressId,
    this.notes,
  }) : items = List.unmodifiable(items);

  final List<CheckoutItemRequest> items;
  final String deliveryAddressId;
  final String? billingAddressId;
  final String? notes;

  Map<String, dynamic> toPreviewJson() => {
    'items': items.map((item) => item.toJson()).toList(growable: false),
    'deliveryAddressId': deliveryAddressId,
    if (billingAddressId != null) 'billingAddressId': billingAddressId,
  };

  Map<String, dynamic> toOrderJson() => {
    ...toPreviewJson(),
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
  };

  @override
  List<Object?> get props => [
    items,
    deliveryAddressId,
    billingAddressId,
    notes,
  ];
}
