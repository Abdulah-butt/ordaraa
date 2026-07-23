import 'package:equatable/equatable.dart';

import 'money.dart';

class CheckoutPreviewItem extends Equatable {
  const CheckoutPreviewItem({
    required this.listingId,
    required this.quantity,
    required this.unitPrice,
    required this.lineSubtotal,
  });

  final String listingId;
  final String quantity;
  final Money unitPrice;
  final Money lineSubtotal;

  CheckoutPreviewItem copyWith({
    String? listingId,
    String? quantity,
    Money? unitPrice,
    Money? lineSubtotal,
  }) {
    return CheckoutPreviewItem(
      listingId: listingId ?? this.listingId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineSubtotal: lineSubtotal ?? this.lineSubtotal,
    );
  }

  @override
  List<Object?> get props => [listingId, quantity, unitPrice, lineSubtotal];
}
