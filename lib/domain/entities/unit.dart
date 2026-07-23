import 'package:equatable/equatable.dart';

import '../../core/enums/unit_kind.dart';
import '../../core/enums/unit_status.dart';

class Unit extends Equatable {
  const Unit({
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

  Unit copyWith({
    String? id,
    String? code,
    String? label,
    UnitKind? kind,
    int? decimalPlaces,
    UnitStatus? status,
  }) {
    return Unit(
      id: id ?? this.id,
      code: code ?? this.code,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, code, label, kind, decimalPlaces, status];
}
