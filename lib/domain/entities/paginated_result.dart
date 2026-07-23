import 'package:equatable/equatable.dart';

class PaginatedResult<T> extends Equatable {
  PaginatedResult({
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

  @override
  List<Object?> get props => [
    items,
    nextCursor,
    hasNextPage,
    limit,
    totalCount,
  ];
}
