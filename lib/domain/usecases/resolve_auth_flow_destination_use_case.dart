import '../../core/enums/auth_flow_destination.dart';
import '../../core/enums/membership_status.dart';
import '../../core/enums/organization_type.dart';
import '../../core/enums/user_role.dart';
import '../../services/secure_storage/secure_storage_service.dart';
import '../entities/auth_result.dart';
import '../entities/organization_membership.dart';
import '../repositories/database/local_database_repository.dart';

class ResolveAuthFlowDestinationUseCase {
  const ResolveAuthFlowDestinationUseCase(
    this._secureStorageService,
    this._localDatabaseRepository,
  );

  final SecureStorageService _secureStorageService;
  final LocalDatabaseRepository _localDatabaseRepository;

  Future<AuthFlowDestination> execute({
    required AuthResult authResult,
    UserRole? intendedRole,
  }) async {
    final persistedRole =
        intendedRole ?? await _secureStorageService.getIntendedUserRole();
    final activeMemberships = authResult.memberships
        .where((item) => item.membership.status == MembershipStatus.active)
        .toList(growable: false);
    final role =
        persistedRole ?? await _inferRoleFromContext(activeMemberships);

    if (role == null) {
      await _localDatabaseRepository.clearSelectedOrganizationId();
      return AuthFlowDestination.chooseRole;
    }

    await _secureStorageService.saveIntendedUserRole(role);
    final membership = _membershipForRole(activeMemberships, role);
    if (membership == null) {
      await _localDatabaseRepository.clearSelectedOrganizationId();
      return role == UserRole.buyer
          ? AuthFlowDestination.buyerRegistration
          : AuthFlowDestination.sellerRegistration;
    }

    await _localDatabaseRepository.saveSelectedOrganizationId(
      membership.organization.id,
    );
    return role == UserRole.buyer
        ? AuthFlowDestination.buyerHome
        : AuthFlowDestination.sellerWorkspace;
  }

  Future<UserRole?> _inferRoleFromContext(
    List<OrganizationMembership> memberships,
  ) async {
    final selectedOrganizationId = await _localDatabaseRepository
        .getSelectedOrganizationId();
    final selectedMembership = memberships
        .where((item) => item.organization.id == selectedOrganizationId)
        .firstOrNull;
    if (selectedMembership != null) {
      return _roleForType(selectedMembership.organization.type);
    }

    for (final role in UserRole.values) {
      if (_membershipForRole(memberships, role) != null) return role;
    }
    return null;
  }

  OrganizationMembership? _membershipForRole(
    List<OrganizationMembership> memberships,
    UserRole role,
  ) {
    return memberships
        .where((item) => _supportsRole(item.organization.type, role))
        .firstOrNull;
  }

  bool _supportsRole(OrganizationType type, UserRole role) {
    return type == OrganizationType.both ||
        (role == UserRole.buyer && type == OrganizationType.buyer) ||
        (role == UserRole.seller && type == OrganizationType.seller);
  }

  UserRole? _roleForType(OrganizationType type) {
    return switch (type) {
      OrganizationType.buyer || OrganizationType.both => UserRole.buyer,
      OrganizationType.seller => UserRole.seller,
      OrganizationType.admin => null,
    };
  }
}
