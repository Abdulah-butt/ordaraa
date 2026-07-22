import 'package:flutter_bloc/flutter_bloc.dart';

import '../entities/category.dart';
import '../repositories/database/remote_database_repository.dart';
import 'category_store_state.dart';

class CategoryStore extends Cubit<CategoryStoreState> {
  CategoryStore(this._remoteDatabaseRepository)
    : super(const CategoryStoreState.initial());

  final RemoteDatabaseRepository _remoteDatabaseRepository;
  Future<List<Category>>? _loadingCategories;

  Future<List<Category>> loadCategories({bool forceRefresh = false}) {
    if (!forceRefresh && state.categories.isNotEmpty) {
      return Future.value(state.categories);
    }
    return _loadingCategories ??= _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    emit(state.copyWith(loading: true, errorMessage: () => null));
    try {
      final categories = await _remoteDatabaseRepository.getCategories();
      final immutableCategories = List<Category>.unmodifiable(categories);
      emit(
        state.copyWith(
          categories: immutableCategories,
          loading: false,
          errorMessage: () => null,
        ),
      );
      return immutableCategories;
    } catch (error) {
      emit(
        state.copyWith(loading: false, errorMessage: () => error.toString()),
      );
      rethrow;
    } finally {
      _loadingCategories = null;
    }
  }
}
