import 'package:ordaraa/data/models/organization_membership_json.dart';

import '../../domain/entities/auth_result.dart';
import 'auth_session_json.dart';
import 'user_json.dart';

class AuthResultJson {
  AuthResultJson({
    this.session,
    required this.user,
    required List<OrganizationMembershipJson> memberships,
  }) : memberships = List.unmodifiable(memberships);

  final AuthSessionJson? session;
  final UserJson user;
  final List<OrganizationMembershipJson> memberships;

  factory AuthResultJson.fromJson(Map<String, dynamic> json) {
    final membershipsJson = json['memberships'] as List<dynamic>;
    return AuthResultJson(
      session: json['session'] != null
          ? AuthSessionJson.fromJson(json['session'] as Map<String, dynamic>)
          : null,
      user: UserJson.fromJson(json['user'] as Map<String, dynamic>),
      memberships: membershipsJson
          .map(
            (membership) => OrganizationMembershipJson.fromJson(
              membership as Map<String, dynamic>,
            ),
          )
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
    'session': session?.toJson(),
    'user': user.toJson(),
    'memberships': memberships
        .map((membership) => membership.toJson())
        .toList(growable: false),
  };

  AuthResult toDomain() => AuthResult(
    session: session?.toDomain(),
    user: user.toDomain(),
    memberships: memberships
        .map((membership) => membership.toDomain())
        .toList(growable: false),
  );
}
