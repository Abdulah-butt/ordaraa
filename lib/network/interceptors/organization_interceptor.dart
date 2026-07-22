import 'package:dio/dio.dart';

import '../../domain/repositories/database/local_database_repository.dart';

class OrganizationInterceptor extends Interceptor {
  OrganizationInterceptor(this._localDatabaseRepository);

  static const organizationHeader = 'X-Organization-Id';

  final LocalDatabaseRepository _localDatabaseRepository;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final organizationId = await _localDatabaseRepository
        .getSelectedOrganizationId();
    if (organizationId != null && organizationId.isNotEmpty) {
      options.headers[organizationHeader] = organizationId;
    } else {
      options.headers.remove(organizationHeader);
    }
    handler.next(options);
  }
}
