import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/stock_status.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';
import 'package:ordaraa/network/request_model/product_listing_request.dart';

void main() {
  test(
    'getProductListings sends filters and maps the paginated response',
    () async {
      final network = _ProductNetworkRepository();
      final repository = RemoteDatabaseImp(network);
      const request = ProductListingRequest(
        limit: 10,
        offset: 20,
        query: 'prawn',
        categoryId: 'category-id',
        sellerOrganizationId: 'seller-id',
      );

      final result = await repository.getProductListings(request: request);

      expect(network.endpoint, APIEndpoint.listings);
      expect(network.returnFullResponse, isTrue);
      expect(network.parameters, {
        'limit': 10,
        'offset': 20,
        'q': 'prawn',
        'categoryId': 'category-id',
        'sellerOrganizationId': 'seller-id',
      });
      expect(result.hasNextPage, isTrue);
      expect(result.limit, 10);
      expect(result.totalCount, 47);
      expect(result.totalPages, 5);
      expect(result.items, hasLength(1));
      final product = result.items.single;
      expect(product.variant.label, 'Black Tiger Shrimp, 16/20');
      expect(product.seller.name, 'Sydney Seafood Co.');
      expect(product.price.amount, '50');
      expect(product.priceUnit.code, 'case');
      expect(product.stockStatus, StockStatus.inStock);
    },
  );

  test('getProductById maps the public listing detail response', () async {
    final network = _ProductNetworkRepository();
    final repository = RemoteDatabaseImp(network);

    final product = await repository.getProductById(
      id: _product['id']! as String,
    );

    expect(
      network.endpoint,
      APIEndpoint.listingById(_product['id']! as String),
    );
    expect(product.id, _product['id']);
    expect(product.seller.name, 'Sydney Seafood Co.');
    expect(product.stockStatus, StockStatus.inStock);
  });
}

class _ProductNetworkRepository implements NetworkRepository {
  String? endpoint;
  Map<String, dynamic>? parameters;
  bool? returnFullResponse;

  @override
  Future<dynamic> sendRequest(
    String endpoint, {
    NetworkRequestMode mode = NetworkRequestMode.get,
    Map<String, dynamic> parameters = const {},
    dynamic body,
    bool isFormData = false,
    bool returnFullResponse = false,
    List<FileField>? fileFields,
  }) async {
    this.endpoint = endpoint;
    this.parameters = parameters;
    this.returnFullResponse = returnFullResponse;
    return endpoint == APIEndpoint.listingById(_product['id']! as String)
        ? _product
        : _response;
  }
}

final _response = <String, dynamic>{
  'success': true,
  'message': 'Listings.',
  'data': [_product],
  'meta': {
    'pagination': {
      'nextCursor': null,
      'hasNextPage': true,
      'limit': 10,
      'totalCount': 47,
      'totalPages': 5,
    },
    'filters': null,
    'sort': null,
  },
};

final _product = <String, dynamic>{
  'id': '9f38d150-7dd4-4dd5-a4ca-aef876074309',
  'publicCode': 'LST-JETVF7',
  'seller': {
    'id': 'f7e63d3d-77e0-4388-b59c-e3a3f5f13fb9',
    'publicCode': 'ORG-Q2U6GD',
    'name': 'Sydney Seafood Co.',
    'type': 'SELLER',
    'logo': null,
    'market': {
      'id': '5bd2595f-bf21-4ba8-8b9d-30f3c245ad3e',
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
    'legalName': 'Sydney Seafood Co. Pty Ltd',
    'registrationNumber': 'ABN 51 824 753 556',
    'taxNumber': null,
    'contactName': 'R. Chen',
    'contactEmail': 'seller@ordara.demo',
    'contactPhone': null,
    'defaultPaymentTerms': 'NET_14',
    'createdAt': '2026-07-21T14:51:27.117Z',
  },
  'variant': {
    'id': '25b05f60-cd3c-4db1-944f-18d6c831bec0',
    'label': 'Black Tiger Shrimp, 16/20',
    'size': '16/20',
    'grade': null,
    'form': null,
    'preservation': 'Frozen',
    'originCountryCode': 'VN',
    'baseUnit': {
      'id': '368ccfcd-5ced-4407-be53-3a691739cff9',
      'code': 'kg',
      'label': 'Kilogram',
      'kind': 'WEIGHT',
      'decimalPlaces': 2,
      'status': 'ACTIVE',
    },
  },
  'sellerSku': 'SHF-PRAWN-1620',
  'titleOverride': null,
  'descriptionOverride': null,
  'images': [
    {
      'url': 'http://localhost:3000/media/product.png',
      'thumbnailUrl': null,
      'fileName': 'black-tiger-prawns.png',
      'alt': null,
    },
  ],
  'price': {'amount': '50', 'currency': 'AUD', 'formatted': 'A\$50.00'},
  'priceUnit': {
    'id': 'd9e16946-15d-4d4e-88c2-e07b2886fa07',
    'code': 'case',
    'label': 'Case',
    'kind': 'PACK',
    'decimalPlaces': 0,
    'status': 'ACTIVE',
  },
  'minimumOrderQuantity': '2',
  'quantityIncrement': '1',
  'leadTimeHours': 48,
  'deliveryTerms': null,
  'status': 'ACTIVE',
  'createdAt': '2026-07-21T14:51:29.289Z',
  'stockStatus': 'IN_STOCK',
};
