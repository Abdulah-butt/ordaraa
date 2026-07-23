import '../../domain/entities/product_variant.dart';
import 'unit_json.dart';

class ProductVariantJson {
  const ProductVariantJson({
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
  final UnitJson baseUnit;

  factory ProductVariantJson.fromJson(Map<String, dynamic> json) {
    return ProductVariantJson(
      id: json['id'] as String,
      label: json['label'] as String,
      size: json['size'] as String?,
      grade: json['grade'] as String?,
      form: json['form'] as String?,
      preservation: json['preservation'] as String?,
      originCountryCode: json['originCountryCode'] as String?,
      baseUnit: UnitJson.fromJson(json['baseUnit'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'size': size,
    'grade': grade,
    'form': form,
    'preservation': preservation,
    'originCountryCode': originCountryCode,
    'baseUnit': baseUnit.toJson(),
  };

  ProductVariant toDomain() {
    return ProductVariant(
      id: id,
      label: label,
      size: size,
      grade: grade,
      form: form,
      preservation: preservation,
      originCountryCode: originCountryCode,
      baseUnit: baseUnit.toDomain(),
    );
  }
}
