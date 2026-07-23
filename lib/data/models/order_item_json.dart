import '../../domain/entities/order_item.dart';
import 'money_json.dart';

class OrderItemJson {
  const OrderItemJson({
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
  final MoneyJson unitPrice;
  final MoneyJson lineSubtotal;
  final MoneyJson lineTotal;

  factory OrderItemJson.fromJson(Map<String, dynamic> json) {
    return OrderItemJson(
      id: json['id'] as String,
      listingId: json['listingId'] as String?,
      productVariantId: json['productVariantId'] as String?,
      sellerSku: json['sellerSku'] as String?,
      productName: json['productName'] as String,
      variantName: json['variantName'] as String,
      quantity: json['quantity'].toString(),
      unit: json['unit'] as String,
      unitPrice: MoneyJson.fromJson(json['unitPrice'] as Map<String, dynamic>),
      lineSubtotal: MoneyJson.fromJson(
        json['lineSubtotal'] as Map<String, dynamic>,
      ),
      lineTotal: MoneyJson.fromJson(json['lineTotal'] as Map<String, dynamic>),
    );
  }

  OrderItem toDomain() => OrderItem(
    id: id,
    listingId: listingId,
    productVariantId: productVariantId,
    sellerSku: sellerSku,
    productName: productName,
    variantName: variantName,
    quantity: quantity,
    unit: unit,
    unitPrice: unitPrice.toDomain(),
    lineSubtotal: lineSubtotal.toDomain(),
    lineTotal: lineTotal.toDomain(),
  );
}
