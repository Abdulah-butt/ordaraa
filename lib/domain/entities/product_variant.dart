import 'package:equatable/equatable.dart';

import 'unit.dart';

class ProductVariant extends Equatable {
  const ProductVariant({
    required this.id,
    required this.label,
    required this.size,
    required this.grade,
    required this.form,
    required this.preservation,
    required this.originCountryCode,
    required this.baseUnit,
  });

  final String id;
  final String label;
  final String? size;
  final String? grade;
  final String? form;
  final String? preservation;
  final String? originCountryCode;
  final Unit baseUnit;

  ProductVariant copyWith({
    String? id,
    String? label,
    String? Function()? size,
    String? Function()? grade,
    String? Function()? form,
    String? Function()? preservation,
    String? Function()? originCountryCode,
    Unit? baseUnit,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      label: label ?? this.label,
      size: size == null ? this.size : size(),
      grade: grade == null ? this.grade : grade(),
      form: form == null ? this.form : form(),
      preservation: preservation == null ? this.preservation : preservation(),
      originCountryCode: originCountryCode == null
          ? this.originCountryCode
          : originCountryCode(),
      baseUnit: baseUnit ?? this.baseUnit,
    );
  }

  @override
  List<Object?> get props => [
    id,
    label,
    size,
    grade,
    form,
    preservation,
    originCountryCode,
    baseUnit,
  ];
}
