import '../../core/enums/unit_kind.dart';
import '../../core/enums/unit_status.dart';
import '../../domain/entities/unit.dart';

class UnitJson {
  const UnitJson({
    required this.id,
    required this.code,
    required this.label,
    required this.kind,
    required this.decimalPlaces,
    required this.status,
  });

  final String id;
  final String code;
  final String label;
  final UnitKind kind;
  final int decimalPlaces;
  final UnitStatus status;

  factory UnitJson.fromJson(Map<String, dynamic> json) {
    return UnitJson(
      id: json['id'] as String,
      code: json['code'] as String,
      label: json['label'] as String,
      kind: UnitKind.fromApiValue(json['kind'] as String),
      decimalPlaces: json['decimalPlaces'] as int,
      status: UnitStatus.fromApiValue(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'label': label,
    'kind': kind.apiValue,
    'decimalPlaces': decimalPlaces,
    'status': status.apiValue,
  };

  Unit toDomain() {
    return Unit(
      id: id,
      code: code,
      label: label,
      kind: kind,
      decimalPlaces: decimalPlaces,
      status: status,
    );
  }
}
