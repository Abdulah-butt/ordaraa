import '../../domain/entities/checkout_preview.dart';
import 'checkout_preview_item_json.dart';
import 'money_json.dart';

class CheckoutPreviewJson {
  CheckoutPreviewJson({
    required this.sellerOrganizationId,
    required this.currencyCode,
    required List<CheckoutPreviewItemJson> items,
    required this.subtotal,
    required this.taxTotal,
    required this.deliveryFee,
    required this.discountTotal,
    required this.total,
  }) : items = List.unmodifiable(items);

  final String sellerOrganizationId;
  final String currencyCode;
  final List<CheckoutPreviewItemJson> items;
  final MoneyJson subtotal;
  final MoneyJson taxTotal;
  final MoneyJson deliveryFee;
  final MoneyJson discountTotal;
  final MoneyJson total;

  factory CheckoutPreviewJson.fromJson(Map<String, dynamic> json) {
    final currency =
        json['currencyCode'] as String? ??
        _currencyFrom(json['total']) ??
        'AUD';
    return CheckoutPreviewJson(
      sellerOrganizationId:
          json['sellerOrganizationId'] as String? ??
          (json['seller'] as Map<String, dynamic>?)?['id'] as String? ??
          '',
      currencyCode: currency,
      items: (json['items'] as List<dynamic>? ?? const [])
          .map(
            (item) => CheckoutPreviewItemJson.fromJson(
              item as Map<String, dynamic>,
              currency: currency,
            ),
          )
          .toList(growable: false),
      subtotal: _money(json['subtotal'], currency),
      taxTotal: _money(json['taxTotal'], currency),
      deliveryFee: _money(json['deliveryFee'], currency),
      discountTotal: _money(json['discountTotal'], currency),
      total: _money(json['total'], currency),
    );
  }

  static String? _currencyFrom(dynamic value) {
    return value is Map<String, dynamic> ? value['currency'] as String? : null;
  }

  static MoneyJson _money(dynamic value, String currency) {
    if (value is Map<String, dynamic>) return MoneyJson.fromJson(value);
    final amount = value?.toString() ?? '0.00';
    return MoneyJson(
      amount: amount,
      currency: currency,
      formatted: '$currency $amount',
    );
  }

  CheckoutPreview toDomain() => CheckoutPreview(
    sellerOrganizationId: sellerOrganizationId,
    currencyCode: currencyCode,
    items: items.map((item) => item.toDomain()).toList(growable: false),
    subtotal: subtotal.toDomain(),
    taxTotal: taxTotal.toDomain(),
    deliveryFee: deliveryFee.toDomain(),
    discountTotal: discountTotal.toDomain(),
    total: total.toDomain(),
  );
}
