import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/get_addresses_use_case.dart';
import '../../../../domain/usecases/delete_address_use_case.dart';
import '../../../../core/alert/app_snack_bar.dart';
import '../../../../domain/entities/address.dart';
import 'saved_addresses_initial_params.dart';
import 'saved_addresses_navigator.dart';
import 'saved_addresses_state.dart';
import 'add_address/add_address_initial_params.dart';

class SavedAddressesCubit extends Cubit<SavedAddressesState> {
  SavedAddressesCubit({
    required this.navigator,
    required this.getAddressesUseCase,
    required this.deleteAddressUseCase,
    required this.snackBar,
  }) : super(SavedAddressesState.initial());

  final SavedAddressesNavigator navigator;
  final GetAddressesUseCase getAddressesUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final AppSnackBar snackBar;

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

  Future<void> openAddAddress() async {
    final address = await navigator.openAddAddress(
      const AddAddressInitialParams(),
    );
    if (address == null || isClosed) return;

    _upsertAddress(address);
  }

  Future<void> editAddress(Address address) async {
    final updated = await navigator.openAddAddress(
      AddAddressInitialParams(address: address),
    );
    if (updated == null || isClosed) return;
    _upsertAddress(updated);
  }

  void confirmDeleteAddress(Address address) {
    if (state.deletingAddressId != null) return;
    navigator.confirmDeleteAddress(
      address: address,
      onConfirm: () => _deleteAddress(address),
    );
  }

  Future<void> _deleteAddress(Address address) async {
    if (state.deletingAddressId != null) return;
    emit(state.copyWith(deletingAddressId: () => address.id));
    try {
      await deleteAddressUseCase.execute(addressId: address.id);
      if (isClosed) return;
      emit(
        state.copyWith(
          addresses: state.addresses
              .where((existing) => existing.id != address.id)
              .toList(),
          deletingAddressId: () => null,
        ),
      );
      snackBar.success('Address deleted');
    } catch (error) {
      if (isClosed) return;
      emit(state.copyWith(deletingAddressId: () => null));
      snackBar.error(error.toString());
    }
  }

  void _upsertAddress(Address address) {
    final addresses = state.addresses
        .where((existing) => existing.id != address.id)
        .map(
          (existing) => address.isDefault && existing.type == address.type
              ? existing.copyWith(isDefault: false)
              : existing,
        )
        .toList();
    final previousIndex = state.addresses.indexWhere(
      (existing) => existing.id == address.id,
    );
    if (previousIndex < 0) {
      emit(state.copyWith(addresses: [address, ...addresses]));
      return;
    }
    final updated = [...addresses];
    updated.insert(previousIndex.clamp(0, updated.length), address);
    emit(state.copyWith(addresses: updated));
  }

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
