class PhoneLoginState {
  const PhoneLoginState({
    required this.loading,
    required this.phoneNumber,
    required this.isPhoneValid,
  });

  final bool loading;
  final String phoneNumber;
  final bool isPhoneValid;

  factory PhoneLoginState.initial() {
    return const PhoneLoginState(
      loading: false,
      phoneNumber: '',
      isPhoneValid: false,
    );
  }

  PhoneLoginState copyWith({
    bool? loading,
    String? phoneNumber,
    bool? isPhoneValid,
  }) {
    return PhoneLoginState(
      loading: loading ?? this.loading,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
    );
  }
}
