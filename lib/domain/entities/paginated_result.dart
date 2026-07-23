import 'package:equatable/equatable.dart';

class PaginatedResult<T> extends Equatable {
  PaginatedResult({
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

  @override
  List<Object?> get props => [
    items,
    hasNextPage,
    limit,
    totalCount,
    totalPages,
  ];
}
