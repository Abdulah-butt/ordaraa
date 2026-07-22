import 'package:equatable/equatable.dart';

import '../../core/enums/category_status.dart';
import 'image_resource.dart';

class Category extends Equatable {
  const Category({
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
  final ImageResource? image;
  final String? parentId;
  final int sortOrder;
  final CategoryStatus status;

  Category copyWith({
    String? id,
    String? name,
    String? slug,
    String? Function()? description,
    ImageResource? Function()? image,
    String? Function()? parentId,
    int? sortOrder,
    CategoryStatus? status,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    description: description == null ? this.description : description(),
    image: image == null ? this.image : image(),
    parentId: parentId == null ? this.parentId : parentId(),
    sortOrder: sortOrder ?? this.sortOrder,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    image,
    parentId,
    sortOrder,
    status,
  ];
}
