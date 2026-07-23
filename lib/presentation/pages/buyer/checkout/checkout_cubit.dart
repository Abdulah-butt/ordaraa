import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/address_type.dart';
import '../../../../domain/entities/address.dart';
import '../../../../domain/stores/cart_store.dart';
import '../../../../domain/usecases/get_addresses_use_case.dart';
import '../../../../domain/usecases/place_order_use_case.dart';
import '../../../../domain/usecases/preview_checkout_use_case.dart';
import '../../../../network/request_model/checkout_item_request.dart';
import '../../../../network/request_model/checkout_request.dart';
import 'checkout_initial_params.dart';
import 'checkout_navigator.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required this.navigator,
    required this.cartStore,
    required this.getAddressesUseCase,
    required this.previewCheckoutUseCase,
    required this.placeOrderUseCase,
    required this.snackBar,
  }) : super(CheckoutState.initial());

  final CheckoutNavigator navigator;
  final CartStore cartStore;
  final GetAddressesUseCase getAddressesUseCase;
  final PreviewCheckoutUseCase previewCheckoutUseCase;
  final PlaceOrderUseCase placeOrderUseCase;
  final AppSnackBar snackBar;
  final notesController = TextEditingController();
  String? _idempotencyKey;

  Future<void> onInit(CheckoutInitialParams initialParams) async {
    emit(CheckoutState.initial());
    if (cartStore.state.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: () => 'Your cart is empty.',
          preview: () => null,
        ),
      );
      return;
    }
    notesController.clear();
    _idempotencyKey = null;
    await _loadAddressesAndPreview();
  }

  Future<void> retry() => _loadAddressesAndPreview();

  Future<void> _loadAddressesAndPreview() async {
    if (state.loading) return;
    emit(state.copyWith(loading: true, errorMessage: () => null));
    try {
      final addresses = await getAddressesUseCase.execute();
      final selected = _preferredAddress(addresses);
      emit(
        state.copyWith(
          addresses: addresses,
          selectedDeliveryAddress: () => selected,
        ),
      );
      if (selected != null) {
        await _preview(selected);
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: () => error.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Address? _preferredAddress(List<Address> addresses) {
    return addresses
            .where(
              (address) =>
                  address.type == AddressType.delivery && address.isDefault,
            )
            .firstOrNull ??
        addresses
            .where((address) => address.type == AddressType.delivery)
            .firstOrNull ??
        addresses.where((address) => address.isDefault).firstOrNull ??
        addresses.firstOrNull;
  }

  Future<void> openAddressPicker() async {
    if (state.addresses.isEmpty) return;
    await navigator.chooseAddress(
      addresses: state.addresses,
      selectedAddress: state.selectedDeliveryAddress,
      onSelected: selectDeliveryAddress,
    );
  }

  void selectDeliveryAddress(Address address) {
    emit(
      state.copyWith(
        selectedDeliveryAddress: () => address,
        preview: () => null,
        errorMessage: () => null,
      ),
    );
    _preview(address);
  }

  Future<void> _preview(Address address) async {
    if (state.previewing || cartStore.state.isEmpty) return;
    emit(state.copyWith(previewing: true, errorMessage: () => null));
    try {
      final preview = await previewCheckoutUseCase.execute(
        request: _request(address),
      );
      emit(state.copyWith(preview: () => preview));
    } catch (error) {
      emit(state.copyWith(errorMessage: () => error.toString()));
    } finally {
      emit(state.copyWith(previewing: false));
    }
  }

  Future<void> placeOrder() async {
    final address = state.selectedDeliveryAddress;
    if (address == null || state.preview == null || state.placingOrder) return;
    emit(state.copyWith(placingOrder: true, errorMessage: () => null));
    try {
      _idempotencyKey ??= _newIdempotencyKey();
      final order = await placeOrderUseCase.execute(
        request: _request(address, includeNotes: true),
        idempotencyKey: _idempotencyKey!,
      );
      cartStore.clear();
      navigator.showConfirmation(order.id);
      _idempotencyKey = null;
    } catch (error) {
      snackBar.error(error.toString());
      emit(state.copyWith(errorMessage: () => error.toString()));
    } finally {
      emit(state.copyWith(placingOrder: false));
    }
  }

  CheckoutRequest _request(Address address, {bool includeNotes = false}) {
    final billing = state.addresses
        .where(
          (candidate) =>
              candidate.type == AddressType.billing && candidate.isDefault,
        )
        .firstOrNull;
    final notes = notesController.text.trim();
    return CheckoutRequest(
      items: cartStore.state.items
          .map(
            (item) => CheckoutItemRequest(
              listingId: item.product.id,
              quantity: item.quantity.toString(),
            ),
          )
          .toList(growable: false),
      deliveryAddressId: address.id,
      billingAddressId: billing?.id,
      notes: includeNotes && notes.isNotEmpty ? notes : null,
    );
  }

  String _newIdempotencyKey() {
    final random = Random.secure();
    return 'ordara-${DateTime.now().microsecondsSinceEpoch}-'
        '${random.nextInt(1 << 32)}';
  }
}
