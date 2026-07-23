import 'package:equatable/equatable.dart';
import 'package:ordaraa/domain/entities/organization_membership.dart';

import 'auth_session.dart';
import 'user.dart';

class AuthResult extends Equatable {
  AuthResult({
    this.session,
    this.user,
    List<OrganizationMembership> memberships = const [],
  }) : memberships = List.unmodifiable(memberships);

  final AuthSession? session;
  final User? user;
  final List<OrganizationMembership> memberships;

  const AuthResult.guest()
    : session = null,
      user = null,
      memberships = const [];

  AuthResult copyWith({
    AuthSession? session,
    User? user,
    List<OrganizationMembership>? memberships,
  }) {
    return AuthResult(
      session: session ?? this.session,
      user: user ?? this.user,
      memberships: memberships ?? this.memberships,
    );
  }

  @override
  List<Object?> get props => [session, user, memberships];
}
