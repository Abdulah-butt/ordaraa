import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';

void main() {
  test(
    'getCategories follows the exact cursor and deduplicates items',
    () async {
      final network = _CategoryNetworkRepository();
      final repository = RemoteDatabaseImp(network);

      final categories = await repository.getCategories();

      expect(network.requests, [
        {'limit': 100},
        {'limit': 100, 'cursor': 'opaque/+== cursor'},
      ]);
      expect(network.returnFullResponseValues, everyElement(isTrue));
      expect(categories.map((category) => category.id), ['seafood', 'produce']);
    },
  );
}

class _CategoryNetworkRepository implements NetworkRepository {
  final requests = <Map<String, dynamic>>[];
  final returnFullResponseValues = <bool>[];

  @override
  Future<dynamic> sendRequest(
    String endpoint, {
    NetworkRequestMode mode = NetworkRequestMode.get,
    Map<String, dynamic> parameters = const {},
    Map<String, dynamic> headers = const {},
    dynamic body,
    bool isFormData = false,
    bool returnFullResponse = false,
    List<FileField>? fileFields,
  }) async {
    expect(endpoint, APIEndpoint.categories);
    requests.add(Map<String, dynamic>.of(parameters));
    returnFullResponseValues.add(returnFullResponse);

    if (parameters['cursor'] == null) {
      return {
        'data': [_category('seafood', 'Seafood')],
        'meta': {
          'pagination': {
            'nextCursor': 'opaque/+== cursor',
            'hasNextPage': true,
            'limit': 100,
            'totalCount': 2,
          },
        },
      };
    }

    expect(parameters['cursor'], 'opaque/+== cursor');
    return {
      'data': [
        _category('seafood', 'Seafood'),
        _category('produce', 'Produce'),
      ],
      'meta': {
        'pagination': {'nextCursor': null, 'hasNextPage': false, 'limit': 100},
      },
    };
  }
}

Map<String, dynamic> _category(String id, String name) => {
  'id': id,
  'name': name,
  'slug': name.toLowerCase(),
  'description': null,
  'image': null,
  'parentId': null,
  'sortOrder': 0,
  'status': 'ACTIVE',
};
