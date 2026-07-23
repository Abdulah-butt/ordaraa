import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/organization_type.dart';
import 'package:ordaraa/core/enums/payment_terms.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';
import 'package:ordaraa/network/request_model/organization_listing_request.dart';
import 'package:ordaraa/network/request_model/update_organization_profile_request.dart';

void main() {
  test('getOrganizations sends filters and maps cursor pagination', () async {
    final network = _OrganizationNetworkRepository();
    final repository = RemoteDatabaseImp(network);

    final result = await repository.getOrganizations(
      request: const OrganizationListingRequest(
        limit: 10,
        cursor: 'organization-cursor/+==',
        query: 'seafood',
      ),
    );

    expect(network.endpoint, APIEndpoint.organizations);
    expect(network.returnFullResponse, isTrue);
    expect(network.parameters, {
      'limit': 10,
      'cursor': 'organization-cursor/+==',
      'type': OrganizationType.seller.apiValue,
      'q': 'seafood',
    });
    expect(result.hasNextPage, isTrue);
    expect(result.totalCount, 47);
    expect(result.nextCursor, 'next-organization-cursor');
    expect(network.parameters, isNot(contains('offset')));
    expect(result.items.single.name, 'Sydney Seafood Co.');
    expect(result.items.single.market.currency, 'AUD');
    expect(result.items.single.verified, isTrue);
  });

  test('getOrganizationById maps organization and addresses', () async {
    final network = _OrganizationNetworkRepository();
    final repository = RemoteDatabaseImp(network);

    final detail = await repository.getOrganizationById(
      id: _organization['id']! as String,
    );

    expect(
      network.endpoint,
      APIEndpoint.organizationById(_organization['id']! as String),
    );
    expect(detail.name, 'Sydney Seafood Co.');
    expect(detail.addresses.single.city, 'Sydney');
    expect(detail.addresses.single.isDefault, isTrue);
  });

  test(
    'getCurrentOrganization uses the current organization endpoint',
    () async {
      final network = _OrganizationNetworkRepository();
      final repository = RemoteDatabaseImp(network);

      final organization = await repository.getCurrentOrganization();

      expect(network.endpoint, APIEndpoint.currentOrganization);
      expect(network.mode, NetworkRequestMode.get);
      expect(organization.addresses.single.city, 'Sydney');
    },
  );

  test(
    'updateCurrentOrganization sends the complete editable profile',
    () async {
      final network = _OrganizationNetworkRepository();
      final repository = RemoteDatabaseImp(network);

      final organization = await repository.updateCurrentOrganization(
        request: const UpdateOrganizationProfileRequest(
          name: 'Harbour Fresh Seafood',
          legalName: 'Harbour Fresh Seafood Pty Ltd',
          registrationNumber: 'ABN 12 345 678 901',
          taxNumber: 'GST-12345',
          contactName: 'Maya Chen',
          contactEmail: 'accounts@harbourfresh.com',
          contactPhone: '+61412345678',
          defaultPaymentTerms: PaymentTerms.net30,
        ),
      );

      expect(network.endpoint, APIEndpoint.currentOrganization);
      expect(network.mode, NetworkRequestMode.patch);
      expect(network.body, {
        'name': 'Harbour Fresh Seafood',
        'legalName': 'Harbour Fresh Seafood Pty Ltd',
        'registrationNumber': 'ABN 12 345 678 901',
        'taxNumber': 'GST-12345',
        'contactName': 'Maya Chen',
        'contactEmail': 'accounts@harbourfresh.com',
        'contactPhone': '+61412345678',
        'defaultPaymentTerms': 'NET_30',
      });
      expect(organization.name, 'Sydney Seafood Co.');
    },
  );
}

class _OrganizationNetworkRepository implements NetworkRepository {
  String? endpoint;
  Map<String, dynamic>? parameters;
  bool? returnFullResponse;
  NetworkRequestMode? mode;
  dynamic body;

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
    this.endpoint = endpoint;
    this.parameters = parameters;
    this.returnFullResponse = returnFullResponse;
    this.mode = mode;
    this.body = body;
    if (endpoint == APIEndpoint.currentOrganization) {
      return mode == NetworkRequestMode.patch ? _organization : _detailResponse;
    }
    return endpoint ==
            APIEndpoint.organizationById(_organization['id']! as String)
        ? _detailResponse
        : _response;
  }
}

final _response = <String, dynamic>{
  'success': true,
  'message': 'Organizations.',
  'data': [_organization],
  'meta': {
    'pagination': {
      'nextCursor': 'next-organization-cursor',
      'hasNextPage': true,
      'limit': 10,
      'totalCount': 47,
    },
  },
};

final _organization = <String, dynamic>{
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
};

final _detailResponse = <String, dynamic>{
  ..._organization,
  'addresses': [
    {
      'id': '87f1fb0c-5bc0-4c21-993f-c6dc61b870b1',
      'type': 'WAREHOUSE',
      'label': 'Main warehouse',
      'contactName': 'R. Chen',
      'contactPhone': null,
      'line1': '24 Harbour Street',
      'line2': null,
      'city': 'Sydney',
      'state': 'NSW',
      'postalCode': '2000',
      'countryCode': 'AU',
      'latitude': null,
      'longitude': null,
      'isDefault': true,
      'createdAt': '2026-07-21T14:51:27.117Z',
      'updatedAt': '2026-07-21T14:51:27.117Z',
    },
  ],
};
