import 'package:equatable/equatable.dart';

import '../../../../core/enums/payment_terms.dart';
import '../../../../domain/entities/organization.dart';

class OrganizationProfileState extends Equatable {
  const OrganizationProfileState({
    required this.organization,
    required this.paymentTerms,
    required this.loading,
    required this.saving,
    required this.errorMessage,
  });

  final Organization? organization;
  final PaymentTerms? paymentTerms;
  final bool loading;
  final bool saving;
  final String? errorMessage;

  factory OrganizationProfileState.initial() => const OrganizationProfileState(
    organization: null,
    paymentTerms: null,
    loading: true,
    saving: false,
    errorMessage: null,
  );

  OrganizationProfileState copyWith({
    Organization? Function()? organization,
    PaymentTerms? Function()? paymentTerms,
    bool? loading,
    bool? saving,
    String? Function()? errorMessage,
  }) {
    return OrganizationProfileState(
      organization: organization == null ? this.organization : organization(),
      paymentTerms: paymentTerms == null ? this.paymentTerms : paymentTerms(),
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }

  @override
  List<Object?> get props => [
    organization,
    paymentTerms,
    loading,
    saving,
    errorMessage,
  ];
}
