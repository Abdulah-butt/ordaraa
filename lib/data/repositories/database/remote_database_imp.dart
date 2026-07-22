import '../../../domain/entities/auth_result.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/market.dart';
import '../../../domain/entities/organization_membership.dart';

import '../../../domain/repositories/database/remote_database_repository.dart';
import '../../../network/api_endpoint.dart';
import '../../../network/network_repository.dart';
import '../../../network/request_model/organization_registration_request.dart';
import '../../../network/request_model/request_phone_otp_request.dart';
import '../../../network/request_model/verify_phone_otp_request.dart';
import '../../models/auth_result_json.dart';
import '../../models/category_json.dart';
import '../../models/market_json.dart';
import '../../models/organization_membership_json.dart';

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
