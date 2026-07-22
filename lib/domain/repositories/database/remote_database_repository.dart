import '../../../network/request_model/organization_registration_request.dart';
import '../../../network/request_model/request_phone_otp_request.dart';
import '../../../network/request_model/verify_phone_otp_request.dart';

import '../../entities/auth_result.dart';
import '../../entities/category.dart';
import '../../entities/market.dart';
import '../../entities/organization_membership.dart';

abstract class RemoteDatabaseRepository {
  Future<void> requestPhoneOtp({required RequestPhoneOtpRequest request});

  Future<AuthResult> verifyPhoneOtp({required VerifyPhoneOtpRequest request});

  Future<AuthResult> getUserProfile();

  Future<List<Market>> getMarkets();

  Future<List<Category>> getCategories();

  Future<OrganizationMembership> createBuyerOrganization({
    required OrganizationRegistrationRequest request,
  });

  Future<void> createSellerApplication({
    required OrganizationRegistrationRequest request,
  });
}
