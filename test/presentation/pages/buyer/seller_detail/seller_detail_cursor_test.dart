import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/core/alert/app_snack_bar.dart';
import 'package:ordaraa/core/navigation/app_navigator.dart';
import 'package:ordaraa/data/repositories/database/remote_database_imp.dart';
import 'package:ordaraa/domain/stores/cart_store.dart';
import 'package:ordaraa/domain/usecases/add_to_cart_use_case.dart';
import 'package:ordaraa/domain/usecases/get_organization_by_id_use_case.dart';
import 'package:ordaraa/domain/usecases/get_product_listings_use_case.dart';
import 'package:ordaraa/network/api_endpoint.dart';
import 'package:ordaraa/network/file_field.dart';
import 'package:ordaraa/network/network_repository.dart';
import 'package:ordaraa/presentation/pages/buyer/seller_detail/seller_detail_cubit.dart';
import 'package:ordaraa/presentation/pages/buyer/seller_detail/seller_detail_initial_params.dart';
import 'package:ordaraa/presentation/pages/buyer/seller_detail/seller_detail_navigator.dart';

import '../../../../fixtures/order_fixture.dart';

void main() {
  test(
    'load more retains first-page totalCount and uses exact cursor',
    () async {
      final network = _SellerDetailNetwork();
      final repository = RemoteDatabaseImp(network);
      final cubit = SellerDetailCubit(
        navigator: SellerDetailNavigator(AppNavigator()),
        getOrganizationByIdUseCase: GetOrganizationByIdUseCase(repository),
        getProductListingsUseCase: GetProductListingsUseCase(repository),
        addToCartUseCase: AddToCartUseCase(CartStore()),
        snackBar: AppSnackBar(),
      );
      addTearDown(cubit.close);
      network.listingPages
        ..add(_listingPage(nextCursor: 'listing/+ cursor==', totalCount: 47))
        ..add(_listingPage(nextCursor: null));

      await cubit.onInit(
        const SellerDetailInitialParams(sellerId: 'seller-id'),
      );
      await cubit.loadMore();

      expect(cubit.state.totalCount, 47);
      expect(network.listingRequests.first, {
        'limit': 10,
        'sellerOrganizationId': 'seller-id',
      });
      expect(network.listingRequests.last['cursor'], 'listing/+ cursor==');
      expect(
        network.listingRequests.every(
          (request) => !request.containsKey('offset'),
        ),
        isTrue,
      );
    },
  );
}

Map<String, dynamic> _listingPage({
  required String? nextCursor,
  int? totalCount,
}) {
  return {
    'data': const <Map<String, dynamic>>[],
    'meta': {
      'pagination': {
        'nextCursor': nextCursor,
        'hasNextPage': nextCursor != null,
        'limit': 10,
        'totalCount': ?totalCount,
      },
    },
  };
}

class _SellerDetailNetwork implements NetworkRepository {
  final listingPages = Queue<Map<String, dynamic>>();
  final listingRequests = <Map<String, dynamic>>[];

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
    if (endpoint == APIEndpoint.organizationById('seller-id')) {
      return organizationJson(
        id: 'seller-id',
        code: 'ORG-SELLER',
        name: 'Sydney Seafood Co.',
        type: 'SELLER',
      );
    }
    listingRequests.add(Map<String, dynamic>.of(parameters));
    return listingPages.removeFirst();
  }
}
