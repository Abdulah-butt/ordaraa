import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/get_addresses_use_case.dart';
import 'saved_addresses_initial_params.dart';
import 'saved_addresses_navigator.dart';
import 'saved_addresses_state.dart';

class SavedAddressesCubit extends Cubit<SavedAddressesState> {
  SavedAddressesCubit({
    required this.navigator,
    required this.getAddressesUseCase,
  }) : super(SavedAddressesState.initial());

  final SavedAddressesNavigator navigator;
  final GetAddressesUseCase getAddressesUseCase;

  void prepareForDisplay() {
    if (state.addresses.isEmpty && !state.loading) {
      emit(state.copyWith(loading: true, errorMessage: () => null));
    }
  }

  Future<void> onInit(SavedAddressesInitialParams initialParams) async {
    if (state.addresses.isNotEmpty) return;
    await _load(initialLoad: true);
  }

  Future<void> retry() => _load();

  Future<void> refresh() => _load(refreshing: true);

  Future<void> _load({
    bool refreshing = false,
    bool initialLoad = false,
  }) async {
    if ((!initialLoad && state.loading) || state.refreshing) return;
    emit(
      state.copyWith(
        loading: !refreshing,
        refreshing: refreshing,
        errorMessage: () => null,
      ),
    );
    try {
      final addresses = await getAddressesUseCase.execute();
      emit(
        state.copyWith(addresses: addresses, loading: false, refreshing: false),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loading: false,
          refreshing: false,
          errorMessage: () => error.toString(),
        ),
      );
    }
  }
}
