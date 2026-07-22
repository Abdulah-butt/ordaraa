import '../../../../domain/entities/market.dart';

class BuyerRegistrationState {
  const BuyerRegistrationState({
    required this.selectedMarket,
    required this.loadingMarkets,
    required this.submitting,
  });

  final Market? selectedMarket;
  final bool loadingMarkets;
  final bool submitting;

  factory BuyerRegistrationState.initial() {
    return const BuyerRegistrationState(
      selectedMarket: null,
      loadingMarkets: false,
      submitting: false,
    );
  }

  BuyerRegistrationState copyWith({
    Market? Function()? selectedMarket,
    bool? loadingMarkets,
    bool? submitting,
  }) {
    return BuyerRegistrationState(
      selectedMarket: selectedMarket == null
          ? this.selectedMarket
          : selectedMarket(),
      loadingMarkets: loadingMarkets ?? this.loadingMarkets,
      submitting: submitting ?? this.submitting,
    );
  }
}
