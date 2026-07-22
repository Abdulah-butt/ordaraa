import 'package:equatable/equatable.dart';

import '../entities/category.dart';

class CategoryStoreState extends Equatable {
  const CategoryStoreState({
    required this.categories,
    required this.loading,
    required this.errorMessage,
  });

  const CategoryStoreState.initial()
    : categories = const [],
      loading = false,
      errorMessage = null;

  final List<Category> categories;
  final bool loading;
  final String? errorMessage;

  CategoryStoreState copyWith({
    List<Category>? categories,
    bool? loading,
    String? Function()? errorMessage,
  }) {
    return CategoryStoreState(
      categories: categories ?? this.categories,
      loading: loading ?? this.loading,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }

  @override
  List<Object?> get props => [categories, loading, errorMessage];
}
