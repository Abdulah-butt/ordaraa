import '../../core/enums/market_status.dart';
import '../../domain/entities/market.dart';

class MarketJson {
  const MarketJson({
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

  factory MarketJson.fromJson(Map<String, dynamic> json) {
    return MarketJson(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      countryCode: json['countryCode'] as String,
      currency: json['currency'] as String,
      timezone: json['timezone'] as String,
      language: json['language'] as String,
      status: MarketStatus.fromApiValue(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'countryCode': countryCode,
    'currency': currency,
    'timezone': timezone,
    'language': language,
    'status': status.apiValue,
  };

  Market toDomain() => Market(
    id: id,
    code: code,
    name: name,
    countryCode: countryCode,
    currency: currency,
    timezone: timezone,
    language: language,
    status: status,
  );
}
