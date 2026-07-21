class OtpVerificationState {
  const OtpVerificationState({required this.code, required this.loading});

  final String code;
  final bool loading;

  factory OtpVerificationState.initial() {
    return const OtpVerificationState(code: '', loading: false);
  }

  OtpVerificationState copyWith({String? code, bool? loading}) {
    return OtpVerificationState(
      code: code ?? this.code,
      loading: loading ?? this.loading,
    );
  }
}
