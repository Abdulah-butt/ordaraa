class SplashState {
  final bool loading;
  const SplashState({required this.loading});

  factory SplashState.initial() => const SplashState(loading: false);

  SplashState copyWith({bool? loading}) =>
      SplashState(loading: loading ?? this.loading);
}
