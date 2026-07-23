class CreateAccountState {
  final bool loading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  const CreateAccountState({
    required this.loading,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
  });

  factory CreateAccountState.initial() => const CreateAccountState(
    loading: false,
    isPasswordVisible: false,
    isConfirmPasswordVisible: false,
  );

  CreateAccountState copyWith({
    bool? loading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) => CreateAccountState(
    loading: loading ?? this.loading,
    isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    isConfirmPasswordVisible:
        isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
  );
}
