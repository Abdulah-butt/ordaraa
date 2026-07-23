import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordaraa/domain/entities/auth_result.dart';
import 'package:ordaraa/domain/entities/organization_membership.dart';
import 'package:ordaraa/domain/entities/user.dart';
import 'package:ordaraa/domain/entities/organization.dart';

class UserStore extends Cubit<AuthResult> {
  UserStore() : super(AuthResult.guest());

  void updateAuthUser(AuthResult result) {
    emit(result);
  }

  void updateUser(User? user) {
    emit(state.copyWith(user: user));
  }

  void addOrganizationMembership(
    OrganizationMembership organizationMembership,
  ) {
    final memberships = [
      ...state.memberships.where(
        (item) => item.membership.id != organizationMembership.membership.id,
      ),
      organizationMembership,
    ];
    emit(state.copyWith(memberships: memberships));
  }

  void updateOrganization(Organization organization) {
    final memberships = state.memberships
        .map(
          (item) => item.organization.id == organization.id
              ? item.copyWith(organization: organization)
              : item,
        )
        .toList(growable: false);
    emit(state.copyWith(memberships: memberships));
  }

  void logoutUser() {
    emit(AuthResult.guest());
  }
}
