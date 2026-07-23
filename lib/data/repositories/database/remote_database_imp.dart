import '../../../domain/entities/auth_result.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/market.dart';
import '../../../domain/entities/organization_membership.dart';
import '../../../domain/entities/organization.dart';
import '../../../domain/entities/paginated_result.dart';
import '../../../domain/entities/product.dart';

import '../../../domain/repositories/database/remote_database_repository.dart';
import '../../../network/api_endpoint.dart';
import '../../../network/network_repository.dart';
import '../../../network/request_model/organization_registration_request.dart';
import '../../../network/request_model/organization_listing_request.dart';
import '../../../network/request_model/product_listing_request.dart';
import '../../../network/request_model/request_phone_otp_request.dart';
import '../../../network/request_model/verify_phone_otp_request.dart';
import '../../models/auth_result_json.dart';
import '../../models/category_json.dart';
import '../../models/market_json.dart';
import '../../models/organization_membership_json.dart';
import '../../models/organization_json.dart';
import '../../models/paginated_result_json.dart';
import '../../models/product_json.dart';

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
    final response = await _networkRepository.sendRequest(APIEndpoint.markets);
    return (response as List<dynamic>)
        .map(
          (market) =>
              MarketJson.fromJson(market as Map<String, dynamic>).toDomain(),
        )
        .toList(growable: false);
  }

  @override
  Future<List<Category>> getCategories() async {
    final response = await _networkRepository.sendRequest(
      APIEndpoint.categories,
    );
    return (response as List<dynamic>)
        .map(
          (category) => CategoryJson.fromJson(
            category as Map<String, dynamic>,
          ).toDomain(),
        )
        .toList(growable: false);
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
