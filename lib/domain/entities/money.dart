import 'package:equatable/equatable.dart';

class Money extends Equatable {
  const Money({
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  final String amount;
  final String currency;
  final String formatted;

  Money copyWith({String? amount, String? currency, String? formatted}) {
    return Money(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      formatted: formatted ?? this.formatted,
    );
  }

  @override
  List<Object?> get props => [amount, currency, formatted];
}
