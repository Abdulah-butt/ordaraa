Map<String, dynamic> orderPageJson({
  required List<Map<String, dynamic>> orders,
  String? nextCursor,
  required bool hasNextPage,
  int limit = 20,
  int? totalCount,
}) {
  return {
    'success': true,
    'message': 'Orders.',
    'data': orders,
    'meta': {
      'pagination': {
        'nextCursor': nextCursor,
        'hasNextPage': hasNextPage,
        'limit': limit,
        'totalCount': ?totalCount,
      },
      'filters': null,
      'sort': null,
    },
  };
}

Map<String, dynamic> orderSummaryJson({
  required String id,
  String status = 'PREPARING',
}) {
  return {
    'id': id,
    'publicNumber': 'ORD-$id',
    'buyer': organizationJson(
      id: 'buyer-id',
      code: 'ORG-BUYER',
      name: 'Harbour Fresh Market',
      type: 'BUYER',
    ),
    'seller': organizationJson(
      id: 'seller-id',
      code: 'ORG-SELLER',
      name: 'Sydney Seafood Co.',
      type: 'SELLER',
    ),
    'status': status,
    'total': {'amount': '684.20', 'currency': 'AUD', 'formatted': r'A$684.20'},
    'placedAt': '2026-07-21T14:51:29.289Z',
    'updatedAt': '2026-07-22T14:51:29.289Z',
  };
}

Map<String, dynamic> organizationJson({
  required String id,
  required String code,
  required String name,
  required String type,
}) {
  return {
    'id': id,
    'publicCode': code,
    'name': name,
    'type': type,
    'logo': null,
    'market': {
      'id': 'market-id',
      'code': 'au',
      'name': 'Australia',
      'countryCode': 'AU',
      'currency': 'AUD',
      'timezone': 'Australia/Sydney',
      'language': 'en-AU',
      'status': 'ACTIVE',
    },
    'status': 'ACTIVE',
    'verified': true,
    'legalName': null,
    'registrationNumber': null,
    'taxNumber': null,
    'contactName': null,
    'contactEmail': null,
    'contactPhone': null,
    'defaultPaymentTerms': 'NET_14',
    'createdAt': '2026-07-21T14:51:27.117Z',
  };
}
