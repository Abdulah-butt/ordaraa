import '../../domain/entities/money.dart';

class MoneyJson {
  const MoneyJson({
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  final String amount;
  final String currency;
  final String formatted;

  factory MoneyJson.fromJson(Map<String, dynamic> json) {
    return MoneyJson(
      amount: json['amount'] as String,
      currency: json['currency'] as String,
      formatted: json['formatted'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currency': currency,
    'formatted': formatted,
  };

  Money toDomain() {
    return Money(amount: amount, currency: currency, formatted: formatted);
  }
}
