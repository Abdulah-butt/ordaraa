import '../../../../domain/entities/market.dart';

enum SellerRegistrationStep { businessDetails, verification }

class SellerRegistrationState {
  const SellerRegistrationState({
    required this.step,
    required this.selectedMarket,
    required this.loadingMarkets,
    required this.authorised,
    required this.documentUploaded,
  });

  final SellerRegistrationStep step;
  final Market? selectedMarket;
  final bool loadingMarkets;
  final bool authorised;
  final bool documentUploaded;

  factory SellerRegistrationState.initial() {
    return const SellerRegistrationState(
      step: SellerRegistrationStep.businessDetails,
      selectedMarket: null,
      loadingMarkets: false,
      authorised: false,
      documentUploaded: false,
    );
  }

  SellerRegistrationState copyWith({
    SellerRegistrationStep? step,
    Market? Function()? selectedMarket,
    bool? loadingMarkets,
    bool? authorised,
    bool? documentUploaded,
  }) {
    return SellerRegistrationState(
      step: step ?? this.step,
      selectedMarket: selectedMarket == null
          ? this.selectedMarket
          : selectedMarket(),
      loadingMarkets: loadingMarkets ?? this.loadingMarkets,
      authorised: authorised ?? this.authorised,
      documentUploaded: documentUploaded ?? this.documentUploaded,
    );
  }
}
