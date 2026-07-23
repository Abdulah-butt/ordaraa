import '../../domain/entities/paginated_result.dart';

class PaginatedResultJson<T> {
  PaginatedResultJson({
    required List<T> items,
    required this.nextCursor,
    required this.hasNextPage,
    required this.limit,
    required this.totalCount,
  }) : items = List.unmodifiable(items);

  final List<T> items;
  final String? nextCursor;
  final bool hasNextPage;
  final int limit;
  final int? totalCount;

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
      nextCursor: pagination['nextCursor'] as String?,
      hasNextPage: pagination['hasNextPage'] as bool,
      limit: pagination['limit'] as int,
      totalCount: pagination['totalCount'] as int?,
    );
  }

  PaginatedResult<R> toDomain<R>(R Function(T item) itemToDomain) {
    return PaginatedResult(
      items: items.map(itemToDomain).toList(growable: false),
      nextCursor: nextCursor,
      hasNextPage: hasNextPage,
      limit: limit,
      totalCount: totalCount,
    );
  }
}
