import 'package:equatable/equatable.dart';

import 'money.dart';

class OrderItem extends Equatable {
  const OrderItem({
    required this.id,
    required this.listingId,
    required this.productVariantId,
    required this.sellerSku,
    required this.productName,
    required this.variantName,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.lineSubtotal,
    required this.lineTotal,
  });

  final String id;
  final String? listingId;
  final String? productVariantId;
  final String? sellerSku;
  final String productName;
  final String variantName;
  final String quantity;
  final String unit;
  final Money unitPrice;
  final Money lineSubtotal;
  final Money lineTotal;

  OrderItem copyWith({
    String? id,
    String? Function()? listingId,
    String? Function()? productVariantId,
    String? Function()? sellerSku,
    String? productName,
    String? variantName,
    String? quantity,
    String? unit,
    Money? unitPrice,
    Money? lineSubtotal,
    Money? lineTotal,
  }) {
    return OrderItem(
      id: id ?? this.id,
      listingId: listingId == null ? this.listingId : listingId(),
      productVariantId: productVariantId == null
          ? this.productVariantId
          : productVariantId(),
      sellerSku: sellerSku == null ? this.sellerSku : sellerSku(),
      productName: productName ?? this.productName,
      variantName: variantName ?? this.variantName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      lineSubtotal: lineSubtotal ?? this.lineSubtotal,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }

  @override
  List<Object?> get props => [
    id,
    listingId,
    productVariantId,
    sellerSku,
    productName,
    variantName,
    quantity,
    unit,
    unitPrice,
    lineSubtotal,
    lineTotal,
  ];
}
