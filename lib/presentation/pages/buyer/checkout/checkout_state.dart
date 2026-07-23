import 'package:equatable/equatable.dart';

import '../../../../domain/entities/address.dart';
import '../../../../domain/entities/checkout_preview.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.addresses,
    required this.selectedDeliveryAddress,
    required this.preview,
    required this.loading,
    required this.previewing,
    required this.placingOrder,
    required this.errorMessage,
  });

  factory CheckoutState.initial() => const CheckoutState(
    addresses: [],
    selectedDeliveryAddress: null,
    preview: null,
    loading: false,
    previewing: false,
    placingOrder: false,
    errorMessage: null,
  );

  final List<Address> addresses;
  final Address? selectedDeliveryAddress;
  final CheckoutPreview? preview;
  final bool loading;
  final bool previewing;
  final bool placingOrder;
  final String? errorMessage;

  CheckoutState copyWith({
    List<Address>? addresses,
    Address? Function()? selectedDeliveryAddress,
    CheckoutPreview? Function()? preview,
    bool? loading,
    bool? previewing,
    bool? placingOrder,
    String? Function()? errorMessage,
  }) {
    return CheckoutState(
      addresses: List.unmodifiable(addresses ?? this.addresses),
      selectedDeliveryAddress: selectedDeliveryAddress == null
          ? this.selectedDeliveryAddress
          : selectedDeliveryAddress(),
      preview: preview == null ? this.preview : preview(),
      loading: loading ?? this.loading,
      previewing: previewing ?? this.previewing,
      placingOrder: placingOrder ?? this.placingOrder,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }

  @override
  List<Object?> get props => [
    addresses,
    selectedDeliveryAddress,
    preview,
    loading,
    previewing,
    placingOrder,
    errorMessage,
  ];
}
