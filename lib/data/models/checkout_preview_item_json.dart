import '../../domain/entities/checkout_preview_item.dart';
import 'money_json.dart';

class CheckoutPreviewItemJson {
  const CheckoutPreviewItemJson({
    required this.listingId,
    required this.quantity,
    required this.unitPrice,
    required this.lineSubtotal,
  });

  final String listingId;
  final String quantity;
  final MoneyJson unitPrice;
  final MoneyJson lineSubtotal;

  factory CheckoutPreviewItemJson.fromJson(
    Map<String, dynamic> json, {
    required String currency,
  }) {
    return CheckoutPreviewItemJson(
      listingId: json['listingId'] as String,
      quantity: json['quantity'].toString(),
      unitPrice: _money(json['unitPrice'], currency),
      lineSubtotal: _money(json['lineSubtotal'], currency),
    );
  }

  static MoneyJson _money(dynamic value, String currency) {
    if (value is Map<String, dynamic>) return MoneyJson.fromJson(value);
    final amount = value.toString();
    return MoneyJson(
      amount: amount,
      currency: currency,
      formatted: '$currency $amount',
    );
  }

  CheckoutPreviewItem toDomain() => CheckoutPreviewItem(
    listingId: listingId,
    quantity: quantity,
    unitPrice: unitPrice.toDomain(),
    lineSubtotal: lineSubtotal.toDomain(),
  );
}
