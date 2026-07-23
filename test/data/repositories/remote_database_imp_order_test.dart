import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/order_list_role.dart';
import 'package:ordaraa/core/enums/order_list_status.dart';
import 'package:ordaraa/core/enums/order_status.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';
import 'package:ordaraa/network/request_model/order_listing_request.dart';

import '../../fixtures/order_fixture.dart';

void main() {
  test('getOrders sends cursor filters and maps cursor metadata', () async {
    final network = _OrderNetworkRepository();
    final repository = RemoteDatabaseImp(network);

    final result = await repository.getOrders(
      request: const OrderListingRequest(
        limit: 20,
        cursor: 'opaque/+ cursor==',
        role: OrderListRole.buyer,
        status: OrderListStatus.active,
      ),
    );

    expect(network.endpoint, APIEndpoint.orders);
    expect(network.parameters, {
      'limit': 20,
      'as': 'buyer',
      'status': 'ACTIVE',
      'cursor': 'opaque/+ cursor==',
    });
    expect(network.parameters, isNot(contains('offset')));
    expect(network.returnFullResponse, isTrue);
    expect(result.nextCursor, 'next/+ cursor==');
    expect(result.hasNextPage, isTrue);
    expect(result.limit, 20);
    expect(result.items, hasLength(1));
    expect(result.items.single.publicNumber, 'ORD-order-id');
    expect(result.items.single.status, OrderStatus.preparing);
    expect(result.items.single.seller.name, 'Sydney Seafood Co.');
    expect(result.items.single.total.formatted, r'A$684.20');
  });

  test('first-page request omits cursor and offset', () {
    const request = OrderListingRequest(
      limit: 20,
      role: OrderListRole.seller,
      status: OrderListStatus.completed,
    );

    expect(request.toQueryParameters(), {
      'limit': 20,
      'as': 'seller',
      'status': 'COMPLETED',
    });
    expect(request.toQueryParameters(), isNot(contains('cursor')));
    expect(request.toQueryParameters(), isNot(contains('offset')));
  });
}

class _OrderNetworkRepository implements NetworkRepository {
  String? endpoint;
  Map<String, dynamic>? parameters;
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
    this.parameters = parameters;
    this.returnFullResponse = returnFullResponse;
    return orderPageJson(
      orders: [orderSummaryJson(id: 'order-id')],
      nextCursor: 'next/+ cursor==',
      hasNextPage: true,
    );
  }
}
