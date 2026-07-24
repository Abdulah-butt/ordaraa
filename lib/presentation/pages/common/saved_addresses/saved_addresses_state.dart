import 'package:equatable/equatable.dart';

import '../../../../domain/entities/address.dart';

class SavedAddressesState extends Equatable {
  const SavedAddressesState({
    required this.addresses,
    required this.loading,
    required this.refreshing,
    required this.errorMessage,
    required this.deletingAddressId,
  });

  final List<Address> addresses;
  final bool loading;
  final bool refreshing;
  final String? errorMessage;
  final String? deletingAddressId;

  factory SavedAddressesState.initial() => const SavedAddressesState(
    addresses: [],
    loading: true,
    refreshing: false,
    errorMessage: null,
    deletingAddressId: null,
  );

  SavedAddressesState copyWith({
    List<Address>? addresses,
    bool? loading,
    bool? refreshing,
    String? Function()? errorMessage,
    String? Function()? deletingAddressId,
  }) {
    return SavedAddressesState(
      addresses: addresses ?? this.addresses,
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      deletingAddressId: deletingAddressId == null
          ? this.deletingAddressId
          : deletingAddressId(),
    );
  }

  @override
  List<Object?> get props => [
    addresses,
    loading,
    refreshing,
    errorMessage,
    deletingAddressId,
  ];
}
