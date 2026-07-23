import '../../../domain/entities/auth_result.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/market.dart';
import '../../../domain/entities/organization_membership.dart';
import '../../../domain/entities/organization.dart';
import '../../../domain/entities/paginated_result.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/entities/checkout_preview.dart';
import '../../../domain/entities/order.dart';
import '../../../core/enums/address_type.dart';

import '../../../domain/repositories/database/remote_database_repository.dart';
import '../../../network/api_endpoint.dart';
import '../../../network/network_repository.dart';
import '../../../network/request_model/organization_registration_request.dart';
import '../../../network/request_model/organization_listing_request.dart';
import '../../../network/request_model/product_listing_request.dart';
import '../../../network/request_model/request_phone_otp_request.dart';
import '../../../network/request_model/verify_phone_otp_request.dart';
import '../../../network/request_model/checkout_request.dart';
import '../../../network/request_model/order_listing_request.dart';
import '../../models/auth_result_json.dart';
import '../../models/category_json.dart';
import '../../models/market_json.dart';
import '../../models/organization_membership_json.dart';
import '../../models/organization_json.dart';
import '../../models/paginated_result_json.dart';
import '../../models/product_json.dart';
import '../../models/address_json.dart';
import '../../models/checkout_preview_json.dart';
import '../../models/order_json.dart';

class RemoteDatabaseImp implements RemoteDatabaseRepository {
  final NetworkRepository _networkRepository;

  RemoteDatabaseImp(this._networkRepository);

  @override
  Future<void> requestPhoneOtp({
    required RequestPhoneOtpRequest request,
  }) async {
    await _networkRepository.sendRequest(
      APIEndpoint.requestPhoneOtp,
      mode: NetworkRequestMode.post,
      body: request.toJson(),
    );
  }

  @override
  Future<AuthResult> verifyPhoneOtp({
    required VerifyPhoneOtpRequest request,
  }) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.verifyPhoneOtp,
      mode: NetworkRequestMode.post,
      body: request.toJson(),
    );
    return AuthResultJson.fromJson(response as Map<String, dynamic>).toDomain();
  }

  @override
  Future<AuthResult> getUserProfile() async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.getProfile,
    );
    return AuthResultJson.fromJson(response as Map<String, dynamic>).toDomain();
  }

  @override
  Future<List<Market>> getMarkets() async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.markets,
    );
    return (response as List)
        .map((data) => MarketJson.fromJson(data).toDomain())
        .toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.categories,
    );
    return (response as List)
        .map((data) => CategoryJson.fromJson(data).toDomain())
        .toList();
  }

  @override
  Future<PaginatedResult<Product>> getProductListings({
    required ProductListingRequest request,
  }) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.listings,
      parameters: request.toQueryParameters(),
      returnFullResponse: true,
    );
    return PaginatedResultJson<ProductJson>.fromJson(
      response as Map<String, dynamic>,
      itemFromJson: ProductJson.fromJson,
    ).toDomain((product) => product.toDomain());
  }

  @override
  Future<Product> getProductById({required String id}) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.listingById(id),
    );
    return ProductJson.fromJson(response as Map<String, dynamic>).toDomain();
  }

  @override
  Future<PaginatedResult<Organization>> getOrganizations({
    required OrganizationListingRequest request,
  }) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.organizations,
      parameters: request.toQueryParameters(),
      returnFullResponse: true,
    );
    return PaginatedResultJson<OrganizationJson>.fromJson(
      response as Map<String, dynamic>,
      itemFromJson: OrganizationJson.fromJson,
    ).toDomain((organization) => organization.toDomain());
  }

  @override
  Future<Organization> getOrganizationById({required String id}) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.organizationById(id),
    );
    return OrganizationJson.fromJson(
      response as Map<String, dynamic>,
    ).toDomain();
  }

  @override
  Future<List<Address>> getAddresses({AddressType? type}) async {
    final addresses = await _getAllCursorPages<AddressJson, Address>(
      endpoint: APIEndpoint.organizationAddresses,
      itemFromJson: AddressJson.fromJson,
      itemToDomain: (address) => address.toDomain(),
      parameters: {if (type != null) 'type': type.apiValue},
    );
    return _deduplicateById(addresses, (address) => address.id);
  }

  Future<List<TDomain>> _getAllCursorPages<TJson, TDomain>({
    required String endpoint,
    required TJson Function(Map<String, dynamic>) itemFromJson,
    required TDomain Function(TJson) itemToDomain,
    Map<String, dynamic> parameters = const {},
  }) async {
    final items = <TDomain>[];
    String? cursor;

    do {
      final response = await _networkRepository.sendRequest(
        endpoint,
        parameters: {'limit': 100, ...parameters, 'cursor': ?cursor},
        returnFullResponse: true,
      );
      final page = PaginatedResultJson<TJson>.fromJson(
        response as Map<String, dynamic>,
        itemFromJson: itemFromJson,
      ).toDomain(itemToDomain);
      items.addAll(page.items);
      cursor = page.hasNextPage ? page.nextCursor : null;
    } while (cursor != null);

    return items;
  }

  List<T> _deduplicateById<T>(List<T> items, String Function(T) idOf) {
    final byId = <String, T>{};
    for (final item in items) {
      byId.putIfAbsent(idOf(item), () => item);
    }
    return byId.values.toList(growable: false);
  }

  @override
  Future<CheckoutPreview> previewCheckout({
    required CheckoutRequest request,
  }) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.checkoutPreview,
      mode: NetworkRequestMode.post,
      body: request.toPreviewJson(),
    );
    return CheckoutPreviewJson.fromJson(
      response as Map<String, dynamic>,
    ).toDomain();
  }

  @override
  Future<Order> placeOrder({
    required CheckoutRequest request,
    required String idempotencyKey,
  }) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.orders,
      mode: NetworkRequestMode.post,
      headers: {'Idempotency-Key': idempotencyKey},
      body: request.toOrderJson(),
    );
    return OrderJson.fromJson(response as Map<String, dynamic>).toDomain();
  }

  @override
  Future<Order> getOrderById({required String id}) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.orderById(id),
    );
    return OrderJson.fromJson(response as Map<String, dynamic>).toDomain();
  }

  @override
  Future<PaginatedResult<Order>> getOrders({
    required OrderListingRequest request,
  }) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.orders,
      parameters: request.toQueryParameters(),
      returnFullResponse: true,
    );
    return PaginatedResultJson<OrderJson>.fromJson(
      response as Map<String, dynamic>,
      itemFromJson: OrderJson.fromJson,
    ).toDomain((order) => order.toDomain());
  }

  @override
  Future<OrganizationMembership> createBuyerOrganization({
    required OrganizationRegistrationRequest request,
  }) async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.createBuyerOrganization,
      mode: NetworkRequestMode.post,
      body: request.toBuyerJson(),
    );
    return OrganizationMembershipJson.fromJson(
      response as Map<String, dynamic>,
    ).toDomain();
  }

  @override
  Future<void> createSellerApplication({
    required OrganizationRegistrationRequest request,
  }) async {
    await _networkRepository.sendRequest(
      APIEndpoint.createSellerApplication,
      mode: NetworkRequestMode.post,
      body: request.toSellerJson(),
    );
  }
}
