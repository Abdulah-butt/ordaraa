import 'dart:async';
import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/enums/order_list_role.dart';
import 'package:ordaraa/core/enums/order_list_status.dart';
import 'package:ordaraa/core/navigation/app_navigator.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/domain/usecases/get_orders_use_case.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';
import 'package:ordaraa/presentation/pages/buyer/orders/buyer_orders_cubit.dart';
import 'package:ordaraa/presentation/pages/buyer/orders/buyer_orders_navigator.dart';

import '../../../../fixtures/order_fixture.dart';

void main() {
  late _ScriptedOrdersNetwork network;
  late BuyerOrdersCubit cubit;

  setUp(() {
    network = _ScriptedOrdersNetwork();
    cubit = BuyerOrdersCubit(
      navigator: BuyerOrdersNavigator(AppNavigator()),
      getOrdersUseCase: GetOrdersUseCase(RemoteDatabaseImp(network)),
    );
  });

  tearDown(() => cubit.close());

  test(
    'first request has no cursor and next request uses exact cursor',
    () async {
      network.enqueue(
        _page(
          ids: ['1'],
          nextCursor: 'opaque/+ cursor==',
          hasNextPage: true,
          totalCount: 47,
        ),
      );
      network.enqueue(_page(ids: ['2'], hasNextPage: false));

      await cubit.refresh();
      await cubit.loadMore();

      expect(network.requests.first, {
        'limit': 20,
        'as': 'buyer',
        'status': 'ACTIVE',
      });
      expect(network.requests.last['cursor'], 'opaque/+ cursor==');
      expect(cubit.state.totalCount, 47);
      expect(
        network.requests.every((request) => !request.containsKey('offset')),
        isTrue,
      );
    },
  );

  test('refresh clears and replaces the previous cursor', () async {
    network.enqueue(
      _page(ids: ['1'], nextCursor: 'old-cursor', hasNextPage: true),
    );
    await cubit.refresh();
    network.enqueue(
      _page(ids: ['2'], nextCursor: 'fresh-cursor', hasNextPage: true),
    );

    await cubit.refresh();

    expect(network.requests.last, isNot(contains('cursor')));
    expect(cubit.state.nextCursor, 'fresh-cursor');
    expect(cubit.state.orders.single.id, '2');
  });

  test('changing status resets cursor and list', () async {
    network.enqueue(
      _page(ids: ['1'], nextCursor: 'active-cursor', hasNextPage: true),
    );
    await cubit.refresh();
    final nextPage = Completer<dynamic>();
    network.enqueueFuture(nextPage.future);

    final change = cubit.selectStatus(OrderListStatus.completed);

    expect(cubit.state.orders, isEmpty);
    expect(cubit.state.nextCursor, isNull);
    expect(network.requests.last['status'], 'COMPLETED');
    expect(network.requests.last, isNot(contains('cursor')));
    nextPage.complete(_page(ids: ['2'], hasNextPage: false));
    await change;
    expect(cubit.state.orders.single.id, '2');
  });

  test('changing buyer/seller role resets cursor and list', () async {
    network.enqueue(
      _page(ids: ['1'], nextCursor: 'buyer-cursor', hasNextPage: true),
    );
    await cubit.refresh();
    final sellerPage = Completer<dynamic>();
    network.enqueueFuture(sellerPage.future);

    final change = cubit.selectRole(OrderListRole.seller);

    expect(cubit.state.orders, isEmpty);
    expect(cubit.state.nextCursor, isNull);
    expect(network.requests.last['as'], 'seller');
    expect(network.requests.last, isNot(contains('cursor')));
    sellerPage.complete(_page(ids: ['2'], hasNextPage: false));
    await change;
  });

  test('hasNextPage false prevents additional requests', () async {
    network.enqueue(_page(ids: ['1'], hasNextPage: false));
    await cubit.refresh();

    await cubit.loadMore();

    expect(network.requests, hasLength(1));
  });

  test('duplicate load-more triggers are ignored', () async {
    network.enqueue(
      _page(ids: ['1'], nextCursor: 'next-cursor', hasNextPage: true),
    );
    await cubit.refresh();
    final nextPage = Completer<dynamic>();
    network.enqueueFuture(nextPage.future);

    final first = cubit.loadMore();
    final duplicate = cubit.loadMore();

    expect(network.requests, hasLength(2));
    nextPage.complete(_page(ids: ['2'], hasNextPage: false));
    await Future.wait([first, duplicate]);
  });

  test('stale responses from a previous status are ignored', () async {
    final stalePage = Completer<dynamic>();
    network.enqueueFuture(stalePage.future);
    final staleRequest = cubit.refresh();
    network.enqueue(_page(ids: ['completed'], hasNextPage: false));

    await cubit.selectStatus(OrderListStatus.completed);
    stalePage.complete(
      _page(ids: ['stale'], nextCursor: 'stale-cursor', hasNextPage: true),
    );
    await staleRequest;

    expect(cubit.state.selectedStatus, OrderListStatus.completed);
    expect(cubit.state.orders.single.id, 'completed');
    expect(cubit.state.nextCursor, isNull);
  });

  test('load-more error preserves items and cursor for retry', () async {
    network.enqueue(
      _page(ids: ['1'], nextCursor: 'retry-cursor', hasNextPage: true),
    );
    await cubit.refresh();
    network.enqueueError(StateError('load more failed'));

    await cubit.loadMore();

    expect(cubit.state.orders.single.id, '1');
    expect(cubit.state.nextCursor, 'retry-cursor');
    expect(cubit.state.hasNextPage, isTrue);
    expect(cubit.state.loadMoreErrorMessage, contains('load more failed'));

    network.enqueue(_page(ids: ['2'], hasNextPage: false));
    await cubit.loadMore();
    expect(network.requests.last['cursor'], 'retry-cursor');
    expect(cubit.state.orders.map((order) => order.id), ['1', '2']);
  });

  test('appended orders are deduplicated by ID', () async {
    network.enqueue(
      _page(ids: ['1'], nextCursor: 'next-cursor', hasNextPage: true),
    );
    await cubit.refresh();
    network.enqueue(_page(ids: ['1', '2'], hasNextPage: false));

    await cubit.loadMore();

    expect(cubit.state.orders.map((order) => order.id), ['1', '2']);
  });

  test('later pages do not overwrite the first-page totalCount', () async {
    network.enqueue(
      _page(
        ids: ['1'],
        nextCursor: 'next-cursor',
        hasNextPage: true,
        totalCount: 47,
      ),
    );
    await cubit.refresh();
    network.enqueue(_page(ids: ['2'], hasNextPage: false));

    await cubit.loadMore();

    expect(cubit.state.totalCount, 47);
  });
}

Map<String, dynamic> _page({
  required List<String> ids,
  String? nextCursor,
  required bool hasNextPage,
  int? totalCount,
}) {
  return orderPageJson(
    orders: ids.map((id) => orderSummaryJson(id: id)).toList(),
    nextCursor: nextCursor,
    hasNextPage: hasNextPage,
    totalCount: totalCount,
  );
}

class _ScriptedOrdersNetwork implements NetworkRepository {
  final requests = <Map<String, dynamic>>[];
  final _responses = Queue<Future<dynamic> Function()>();

  void enqueue(dynamic response) {
    _responses.add(() async => response);
  }

  void enqueueFuture(Future<dynamic> response) {
    _responses.add(() => response);
  }

  void enqueueError(Object error) {
    _responses.add(() => Future<dynamic>.error(error));
  }

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
  }) {
    requests.add(Map<String, dynamic>.of(parameters));
    return _responses.removeFirst()();
  }
}
