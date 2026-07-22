import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/repositories/database/local_database_repository.dart';

class HiveDatabaseImp implements LocalDatabaseRepository {
  static const String _authBoxName = 'authBox';
  static const String _selectedOrganizationIdKey = 'selected_organization_id';

  Box<dynamic> get _authBox => Hive.box<dynamic>(_authBoxName);

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(_authBoxName);
  }

  @override
  Future<void> saveSelectedOrganizationId(String organizationId) {
    return _authBox.put(_selectedOrganizationIdKey, organizationId);
  }

  @override
  Future<String?> getSelectedOrganizationId() async {
    return _authBox.get(_selectedOrganizationIdKey) as String?;
  }

  @override
  Future<void> clearSelectedOrganizationId() {
    return _authBox.delete(_selectedOrganizationIdKey);
  }
}
