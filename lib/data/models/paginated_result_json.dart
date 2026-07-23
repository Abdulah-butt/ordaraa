import '../../domain/entities/paginated_result.dart';

class PaginatedResultJson<T> {
  PaginatedResultJson({
    required List<T> items,
    required this.hasNextPage,
    required this.limit,
    required this.totalCount,
    required this.totalPages,
  }) : items = List.unmodifiable(items);

  final List<T> items;
  final bool hasNextPage;
  final int limit;
  final int? totalCount;
  final int? totalPages;

  factory PaginatedResultJson.fromJson(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic> json) itemFromJson,
  }) {
    final meta = json['meta'] as Map<String, dynamic>;
    final pagination = meta['pagination'] as Map<String, dynamic>;
    return PaginatedResultJson(
      items: (json['data'] as List<dynamic>)
          .map((item) => itemFromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      hasNextPage: pagination['hasNextPage'] as bool,
      limit: pagination['limit'] as int,
      totalCount: pagination['totalCount'] as int?,
      totalPages: pagination['totalPages'] as int?,
    );
  }

  PaginatedResult<R> toDomain<R>(R Function(T item) itemToDomain) {
    return PaginatedResult(
      items: items.map(itemToDomain).toList(growable: false),
      hasNextPage: hasNextPage,
      limit: limit,
      totalCount: totalCount,
      totalPages: totalPages,
    );
  }
}
