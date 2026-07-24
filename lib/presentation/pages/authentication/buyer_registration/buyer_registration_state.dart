import '../../../../domain/entities/market.dart';

class BuyerRegistrationState {
  const BuyerRegistrationState({
    required this.selectedMarket,
    required this.loadingMarkets,
    required this.submitting,
    required this.isLoggingOut,
  });

  final Market? selectedMarket;
  final bool loadingMarkets;
  final bool submitting;
  final bool isLoggingOut;

  factory BuyerRegistrationState.initial() {
    return const BuyerRegistrationState(
      selectedMarket: null,
      loadingMarkets: false,
      submitting: false,
      isLoggingOut: false,
    );
  }

  BuyerRegistrationState copyWith({
    Market? Function()? selectedMarket,
    bool? loadingMarkets,
    bool? submitting,
    bool? isLoggingOut,
  }) {
    return BuyerRegistrationState(
      selectedMarket: selectedMarket == null
          ? this.selectedMarket
          : selectedMarket(),
      loadingMarkets: loadingMarkets ?? this.loadingMarkets,
      submitting: submitting ?? this.submitting,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }
}
