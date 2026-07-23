import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/auth_flow_destination.dart';
import 'package:ordaraa/core/enums/user_role.dart';
import 'package:ordaraa/data/models/organization_membership_json.dart';
import 'package:ordaraa/domain/entities/auth_result.dart';
import 'package:ordaraa/domain/entities/organization_membership.dart';
import 'package:ordaraa/domain/repositories/database/local_database_repository.dart';
import 'package:ordaraa/domain/usecases/resolve_auth_flow_destination_use_case.dart';
import 'package:ordaraa/services/secure_storage/secure_storage_service.dart';

import '../../fixtures/order_fixture.dart';

void main() {
  test('buyer without an organization resumes buyer registration', () async {
    final storage = _RoleStorage(UserRole.buyer);
    final database = _RoleLocalDatabase('stale-organization');
    final useCase = ResolveAuthFlowDestinationUseCase(storage, database);

    final destination = await useCase.execute(
      authResult: const AuthResult.guest(),
    );

    expect(destination, AuthFlowDestination.buyerRegistration);
    expect(database.organizationId, isNull);
  });

  test('seller without an organization resumes seller registration', () async {
    final storage = _RoleStorage(UserRole.seller);
    final useCase = ResolveAuthFlowDestinationUseCase(
      storage,
      _RoleLocalDatabase(),
    );

    final destination = await useCase.execute(
      authResult: const AuthResult.guest(),
    );

    expect(destination, AuthFlowDestination.sellerRegistration);
  });

  test('buyer with an active buyer organization opens buyer home', () async {
    final storage = _RoleStorage(UserRole.buyer);
    final database = _RoleLocalDatabase();
    final useCase = ResolveAuthFlowDestinationUseCase(storage, database);

    final destination = await useCase.execute(
      authResult: AuthResult(
        memberships: [_membership(id: 'buyer-id', type: 'BUYER')],
      ),
    );

    expect(destination, AuthFlowDestination.buyerHome);
    expect(database.organizationId, 'buyer-id');
  });

  test(
    'persisted role never reuses an organization from another role',
    () async {
      final storage = _RoleStorage(UserRole.buyer);
      final database = _RoleLocalDatabase('seller-id');
      final useCase = ResolveAuthFlowDestinationUseCase(storage, database);

      final destination = await useCase.execute(
        authResult: AuthResult(
          memberships: [_membership(id: 'seller-id', type: 'SELLER')],
        ),
      );

      expect(destination, AuthFlowDestination.buyerRegistration);
      expect(database.organizationId, isNull);
    },
  );

  test(
    'legacy session infers role from its valid selected organization',
    () async {
      final storage = _RoleStorage();
      final database = _RoleLocalDatabase('seller-id');
      final useCase = ResolveAuthFlowDestinationUseCase(storage, database);

      final destination = await useCase.execute(
        authResult: AuthResult(
          memberships: [
            _membership(id: 'buyer-id', type: 'BUYER'),
            _membership(id: 'seller-id', type: 'SELLER'),
          ],
        ),
      );

      expect(destination, AuthFlowDestination.sellerWorkspace);
      expect(storage.intendedRole, UserRole.seller);
      expect(database.organizationId, 'seller-id');
    },
  );

  test(
    'session without a role or organization returns to role selection',
    () async {
      final useCase = ResolveAuthFlowDestinationUseCase(
        _RoleStorage(),
        _RoleLocalDatabase(),
      );

      final destination = await useCase.execute(
        authResult: const AuthResult.guest(),
      );

      expect(destination, AuthFlowDestination.chooseRole);
    },
  );
}

OrganizationMembership _membership({
  required String id,
  required String type,
  String status = 'ACTIVE',
}) {
  return OrganizationMembershipJson.fromJson({
    'membership': {
      'id': 'membership-$id',
      'organizationId': id,
      'userId': 'user-id',
      'role': 'OWNER',
      'status': status,
      'joinedAt': '2026-07-21T14:51:27.117Z',
    },
    'organization': organizationJson(
      id: id,
      code: 'ORG-$id',
      name: id,
      type: type,
    ),
  }).toDomain();
}

class _RoleStorage implements SecureStorageService {
  _RoleStorage([this.intendedRole]);

  UserRole? intendedRole;

  @override
  Future<UserRole?> getIntendedUserRole() async => intendedRole;

  @override
  Future<void> saveIntendedUserRole(UserRole role) async {
    intendedRole = role;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RoleLocalDatabase implements LocalDatabaseRepository {
  _RoleLocalDatabase([this.organizationId]);

  String? organizationId;

  @override
  Future<void> clearSelectedOrganizationId() async => organizationId = null;

  @override
  Future<String?> getSelectedOrganizationId() async => organizationId;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> saveSelectedOrganizationId(String organizationId) async {
    this.organizationId = organizationId;
  }
}
