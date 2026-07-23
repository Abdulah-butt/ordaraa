import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/address_type.dart';
import 'package:ordaraa/core/enums/order_status.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';
import 'package:ordaraa/network/request_model/checkout_item_request.dart';
import 'package:ordaraa/network/request_model/checkout_request.dart';

void main() {
  late _CheckoutNetworkRepository network;
  late RemoteDatabaseImp repository;

  setUp(() {
    network = _CheckoutNetworkRepository();
    repository = RemoteDatabaseImp(network);
  });

  test(
    'getAddresses requests the complete organization address list',
    () async {
      final addresses = await repository.getAddresses(
        type: AddressType.delivery,
      );

      expect(network.endpoint, APIEndpoint.organizationAddresses);
      expect(network.parameters, {'limit': 100, 'type': 'DELIVERY'});
      expect(network.returnFullResponse, isTrue);
      expect(addresses.single.line1, '24 Harbour Street');
    },
  );

  test('previewCheckout sends cart and maps authoritative totals', () async {
    final preview = await repository.previewCheckout(request: _request);

    expect(network.endpoint, APIEndpoint.checkoutPreview);
    expect(network.mode, NetworkRequestMode.post);
    expect(network.body, _request.toPreviewJson());
    expect(preview.items.single.lineSubtotal.amount, '100.00');
    expect(preview.total.amount, '100.00');
  });

  test(
    'placeOrder sends a stable idempotency header and maps summary',
    () async {
      final order = await repository.placeOrder(
        request: _request,
        idempotencyKey: 'ordara-test-key',
      );

      expect(network.endpoint, APIEndpoint.orders);
      expect(network.headers, {'Idempotency-Key': 'ordara-test-key'});
      expect(network.body, _request.toOrderJson());
      expect(order.publicNumber, 'ORD-10482');
      expect(order.status, OrderStatus.pending);
    },
  );

  test('getOrderById maps snapshots, items, and timeline', () async {
    final order = await repository.getOrderById(id: 'order-id');

    expect(network.endpoint, APIEndpoint.orderById('order-id'));
    expect(order.deliveryAddress?.city, 'Sydney');
    expect(order.items.single.productName, 'Black Tiger Shrimp');
    expect(order.timeline.single.toStatus, OrderStatus.pending);
    expect(order.paymentTerms?.apiValue, 'NET_14');
  });
}

final _request = CheckoutRequest(
  items: const [CheckoutItemRequest(listingId: 'listing-id', quantity: '2')],
  deliveryAddressId: 'address-id',
  notes: 'Leave at receiving.',
);

class _CheckoutNetworkRepository implements NetworkRepository {
  String? endpoint;
  NetworkRequestMode? mode;
  Map<String, dynamic>? parameters;
  Map<String, dynamic>? headers;
  dynamic body;
  bool? returnFullResponse;

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
    this.mode = mode;
    this.parameters = parameters;
    this.headers = headers;
    this.body = body;
    this.returnFullResponse = returnFullResponse;
    if (endpoint == APIEndpoint.organizationAddresses) {
      return {
        'data': [_address],
        'meta': {
          'pagination': {
            'nextCursor': null,
            'hasNextPage': false,
            'limit': 100,
          },
        },
      };
    }
    if (endpoint == APIEndpoint.checkoutPreview) return _preview;
    if (endpoint == APIEndpoint.orders) return _orderSummary;
    if (endpoint == APIEndpoint.orderById('order-id')) return _orderDetail;
    throw StateError('Unexpected endpoint: $endpoint');
  }
}

final _address = <String, dynamic>{
  'id': 'address-id',
  'type': 'DELIVERY',
  'label': 'Receiving dock',
  'contactName': 'Maya Chen',
  'contactPhone': '+61255550117',
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
};

final _preview = <String, dynamic>{
  'sellerOrganizationId': 'seller-id',
  'currencyCode': 'AUD',
  'items': [
    {
      'listingId': 'listing-id',
      'quantity': '2',
      'unitPrice': '50.00',
      'lineSubtotal': '100.00',
    },
  ],
  'subtotal': '100.00',
  'taxTotal': '0.00',
  'deliveryFee': '0.00',
  'discountTotal': '0.00',
  'total': '100.00',
};

final _orderSummary = <String, dynamic>{
  'id': 'order-id',
  'publicNumber': 'ORD-10482',
  'buyer': _organization('buyer-id', 'Harbour Fresh Market', 'BUYER'),
  'seller': _organization('seller-id', 'Sydney Seafood Co.', 'SELLER'),
  'status': 'PENDING',
  'total': {'amount': '100.00', 'currency': 'AUD', 'formatted': 'A\$100.00'},
  'placedAt': '2026-07-23T01:00:00.000Z',
  'updatedAt': '2026-07-23T01:00:00.000Z',
};

final _orderDetail = <String, dynamic>{
  ..._orderSummary,
  'placedBy': {
    'id': 'user-id',
    'displayName': 'Maya Chen',
    'avatar': null,
    'locale': 'en-AU',
    'status': 'ACTIVE',
    'platformRole': null,
  },
  'subtotal': {'amount': '100.00', 'currency': 'AUD', 'formatted': 'A\$100.00'},
  'taxTotal': {'amount': '0.00', 'currency': 'AUD', 'formatted': 'A\$0.00'},
  'deliveryFee': {'amount': '0.00', 'currency': 'AUD', 'formatted': 'A\$0.00'},
  'discountTotal': {
    'amount': '0.00',
    'currency': 'AUD',
    'formatted': 'A\$0.00',
  },
  'deliveryAddress': {..._address, 'organizationId': 'buyer-id'},
  'billingAddress': null,
  'paymentTerms': 'NET_14',
  'notes': 'Leave at receiving.',
  'confirmedAt': null,
  'cancelledAt': null,
  'items': [
    {
      'id': 'item-id',
      'listingId': 'listing-id',
      'productVariantId': 'variant-id',
      'sellerSku': 'PRAWN-01',
      'productName': 'Black Tiger Shrimp',
      'variantName': '16/20',
      'quantity': '2',
      'unit': 'Case',
      'unitPrice': {
        'amount': '50.00',
        'currency': 'AUD',
        'formatted': 'A\$50.00',
      },
      'lineSubtotal': {
        'amount': '100.00',
        'currency': 'AUD',
        'formatted': 'A\$100.00',
      },
      'lineTotal': {
        'amount': '100.00',
        'currency': 'AUD',
        'formatted': 'A\$100.00',
      },
    },
  ],
  'timeline': [
    {
      'id': 'event-id',
      'fromStatus': null,
      'toStatus': 'PENDING',
      'reasonCode': null,
      'note': null,
      'createdAt': '2026-07-23T01:00:00.000Z',
    },
  ],
};

Map<String, dynamic> _organization(String id, String name, String type) => {
  'id': id,
  'publicCode': 'ORG-TEST',
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
