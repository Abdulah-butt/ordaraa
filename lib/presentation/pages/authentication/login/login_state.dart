class LoginState {
  final bool loading;
  final bool isPasswordVisible;
  const LoginState({required this.loading, required this.isPasswordVisible});

  factory LoginState.initial() =>
      const LoginState(loading: false, isPasswordVisible: false);

  LoginState copyWith({bool? loading, bool? isPasswordVisible}) => LoginState(
        loading: loading ?? this.loading,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      );
}
