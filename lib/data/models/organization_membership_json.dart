import '../../domain/entities/organization_membership.dart';
import 'membership_json.dart';
import 'organization_json.dart';

class OrganizationMembershipJson {
  const OrganizationMembershipJson({
    required this.membership,
    required this.organization,
  });

  final MembershipJson membership;
  final OrganizationJson organization;

  factory OrganizationMembershipJson.fromJson(Map<String, dynamic> json) {
    return OrganizationMembershipJson(
      membership: MembershipJson.fromJson(
        json['membership'] as Map<String, dynamic>,
      ),
      organization: OrganizationJson.fromJson(
        json['organization'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'membership': membership.toJson(),
    'organization': organization.toJson(),
  };

  OrganizationMembership toDomain() => OrganizationMembership(
    membership: membership.toDomain(),
    organization: organization.toDomain(),
  );
}
