class BuyerRegistrationState {
  const BuyerRegistrationState({required this.market});

  final String market;

  factory BuyerRegistrationState.initial() {
    return const BuyerRegistrationState(market: 'Australia');
  }

  BuyerRegistrationState copyWith({String? market}) {
    return BuyerRegistrationState(market: market ?? this.market);
  }
}
