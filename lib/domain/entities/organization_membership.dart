import 'package:equatable/equatable.dart';

import 'membership.dart';
import 'organization.dart';

class OrganizationMembership extends Equatable {
  const OrganizationMembership({
    required this.membership,
    required this.organization,
  });

  final Membership membership;
  final Organization organization;

  OrganizationMembership copyWith({
    Membership? membership,
    Organization? organization,
  }) {
    return OrganizationMembership(
      membership: membership ?? this.membership,
      organization: organization ?? this.organization,
    );
  }

  @override
  List<Object?> get props => [membership, organization];
}
