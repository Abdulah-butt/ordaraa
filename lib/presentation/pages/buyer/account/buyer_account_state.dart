import 'package:equatable/equatable.dart';

class BuyerAccountState extends Equatable {
  const BuyerAccountState({
    required this.initials,
    required this.organizationName,
    required this.organizationSubtitle,
    required this.organizationVerified,
    required this.isLoggingOut,
  });

  final String initials;
  final String organizationName;
  final String organizationSubtitle;
  final bool organizationVerified;
  final bool isLoggingOut;

  factory BuyerAccountState.initial() => const BuyerAccountState(
    initials: '',
    organizationName: '',
    organizationSubtitle: '',
    organizationVerified: false,
    isLoggingOut: false,
  );

  BuyerAccountState copyWith({
    String? initials,
    String? organizationName,
    String? organizationSubtitle,
    bool? organizationVerified,
    bool? isLoggingOut,
  }) {
    return BuyerAccountState(
      initials: initials ?? this.initials,
      organizationName: organizationName ?? this.organizationName,
      organizationSubtitle: organizationSubtitle ?? this.organizationSubtitle,
      organizationVerified: organizationVerified ?? this.organizationVerified,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => [
    initials,
    organizationName,
    organizationSubtitle,
    organizationVerified,
    isLoggingOut,
  ];
}
