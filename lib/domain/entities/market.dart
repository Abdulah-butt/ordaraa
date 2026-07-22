import 'package:equatable/equatable.dart';

import '../../core/enums/market_status.dart';

class Market extends Equatable {
  const Market({
    required this.id,
    required this.code,
    required this.name,
    required this.countryCode,
    required this.currency,
    required this.timezone,
    required this.language,
    required this.status,
  });

  final String id;
  final String code;
  final String name;
  final String countryCode;
  final String currency;
  final String timezone;
  final String language;
  final MarketStatus status;

  Market copyWith({
    String? id,
    String? code,
    String? name,
    String? countryCode,
    String? currency,
    String? timezone,
    String? language,
    MarketStatus? status,
  }) {
    return Market(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    countryCode,
    currency,
    timezone,
    language,
    status,
  ];
}
