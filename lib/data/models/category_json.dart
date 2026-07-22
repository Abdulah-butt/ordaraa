import '../../core/enums/category_status.dart';
import '../../domain/entities/category.dart';
import 'image_resource_json.dart';

class CategoryJson {
  const CategoryJson({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.parentId,
    required this.sortOrder,
    required this.status,
  });

  final String id;
  final String name;
  final String slug;
  final String? description;
  final ImageResourceJson? image;
  final String? parentId;
  final int sortOrder;
  final CategoryStatus status;

  factory CategoryJson.fromJson(Map<String, dynamic> json) => CategoryJson(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
    description: json['description'] as String?,
    image: json['image'] == null
        ? null
        : ImageResourceJson.fromJson(json['image'] as Map<String, dynamic>),
    parentId: json['parentId'] as String?,
    sortOrder: json['sortOrder'] as int,
    status: CategoryStatus.fromApiValue(json['status'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'image': image?.toJson(),
    'parentId': parentId,
    'sortOrder': sortOrder,
    'status': status.apiValue,
  };

  Category toDomain() => Category(
    id: id,
    name: name,
    slug: slug,
    description: description,
    image: image?.toDomain(),
    parentId: parentId,
    sortOrder: sortOrder,
    status: status,
  );
}
