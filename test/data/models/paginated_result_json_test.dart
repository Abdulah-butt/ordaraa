import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/data/models/paginated_result_json.dart';

void main() {
  test('parses first-page cursor metadata and totalCount', () {
    final result = PaginatedResultJson<Map<String, dynamic>>.fromJson(
      _response(nextCursor: 'opaque/+==', totalCount: 47),
      itemFromJson: (json) => json,
    ).toDomain((item) => item);

    expect(result.nextCursor, 'opaque/+==');
    expect(result.hasNextPage, isTrue);
    expect(result.limit, 20);
    expect(result.totalCount, 47);
  });

  test('accepts later cursor pages without totalCount', () {
    final result = PaginatedResultJson<Map<String, dynamic>>.fromJson(
      _response(nextCursor: null),
      itemFromJson: (json) => json,
    ).toDomain((item) => item);

    expect(result.nextCursor, isNull);
    expect(result.totalCount, isNull);
  });
}

Map<String, dynamic> _response({required String? nextCursor, int? totalCount}) {
  return {
    'data': [
      {'id': 'item-id'},
    ],
    'meta': {
      'pagination': {
        'nextCursor': nextCursor,
        'hasNextPage': nextCursor != null,
        'limit': 20,
        'totalCount': ?totalCount,
      },
    },
  };
}
