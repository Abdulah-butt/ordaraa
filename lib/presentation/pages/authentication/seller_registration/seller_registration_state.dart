enum SellerRegistrationStep { businessDetails, verification }

class SellerRegistrationState {
  const SellerRegistrationState({
    required this.step,
    required this.market,
    required this.authorised,
    required this.documentUploaded,
  });

  final SellerRegistrationStep step;
  final String market;
  final bool authorised;
  final bool documentUploaded;

  factory SellerRegistrationState.initial() {
    return const SellerRegistrationState(
      step: SellerRegistrationStep.businessDetails,
      market: 'Australia',
      authorised: true,
      documentUploaded: false,
    );
  }

  SellerRegistrationState copyWith({
    SellerRegistrationStep? step,
    String? market,
    bool? authorised,
    bool? documentUploaded,
  }) {
    return SellerRegistrationState(
      step: step ?? this.step,
      market: market ?? this.market,
      authorised: authorised ?? this.authorised,
      documentUploaded: documentUploaded ?? this.documentUploaded,
    );
  }
}
