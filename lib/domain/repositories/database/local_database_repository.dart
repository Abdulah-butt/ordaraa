abstract class LocalDatabaseRepository {
  Future<void> initialize();

  Future<void> saveSelectedOrganizationId(String organizationId);

  Future<String?> getSelectedOrganizationId();

  Future<void> clearSelectedOrganizationId();
}
