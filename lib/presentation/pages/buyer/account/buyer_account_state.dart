import 'package:equatable/equatable.dart';

class BuyerAccountState extends Equatable {
  const BuyerAccountState({
    required this.displayName,
    required this.initials,
    required this.organizationName,
    required this.roleLabel,
    required this.isLoggingOut,
  });

  final String displayName;
  final String initials;
  final String organizationName;
  final String roleLabel;
  final bool isLoggingOut;

  factory BuyerAccountState.initial() => const BuyerAccountState(
    displayName: '',
    initials: '',
    organizationName: '',
    roleLabel: '',
    isLoggingOut: false,
  );

  BuyerAccountState copyWith({
    String? displayName,
    String? initials,
    String? organizationName,
    String? roleLabel,
    bool? isLoggingOut,
  }) {
    return BuyerAccountState(
      displayName: displayName ?? this.displayName,
      initials: initials ?? this.initials,
      organizationName: organizationName ?? this.organizationName,
      roleLabel: roleLabel ?? this.roleLabel,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => [
    displayName,
    initials,
    organizationName,
    roleLabel,
    isLoggingOut,
  ];
}
