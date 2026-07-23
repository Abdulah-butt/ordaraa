import 'package:equatable/equatable.dart';

import '../../../../domain/entities/address.dart';

class SavedAddressesState extends Equatable {
  const SavedAddressesState({
    required this.addresses,
    required this.loading,
    required this.refreshing,
    required this.errorMessage,
  });

  final List<Address> addresses;
  final bool loading;
  final bool refreshing;
  final String? errorMessage;

  factory SavedAddressesState.initial() => const SavedAddressesState(
    addresses: [],
    loading: true,
    refreshing: false,
    errorMessage: null,
  );

  SavedAddressesState copyWith({
    List<Address>? addresses,
    bool? loading,
    bool? refreshing,
    String? Function()? errorMessage,
  }) {
    return SavedAddressesState(
      addresses: addresses ?? this.addresses,
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }

  @override
  List<Object?> get props => [addresses, loading, refreshing, errorMessage];
}
