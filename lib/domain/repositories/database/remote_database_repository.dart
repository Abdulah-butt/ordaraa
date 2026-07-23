import '../../../network/request_model/organization_registration_request.dart';
import '../../../network/request_model/organization_listing_request.dart';
import '../../../network/request_model/product_listing_request.dart';
import '../../../network/request_model/request_phone_otp_request.dart';
import '../../../network/request_model/verify_phone_otp_request.dart';

import '../../entities/auth_result.dart';
import '../../entities/category.dart';
import '../../entities/market.dart';
import '../../entities/organization_membership.dart';
import '../../entities/organization.dart';
import '../../entities/paginated_result.dart';
import '../../entities/product.dart';

abstract class RemoteDatabaseRepository {
  Future<void> requestPhoneOtp({required RequestPhoneOtpRequest request});

  Future<AuthResult> verifyPhoneOtp({required VerifyPhoneOtpRequest request});

  Future<AuthResult> getUserProfile();

  Future<List<Market>> getMarkets();

  Future<List<Category>> getCategories();

  Future<PaginatedResult<Product>> getProductListings({
    required ProductListingRequest request,
  });

  Future<Product> getProductById({required String id});

  Future<PaginatedResult<Organization>> getOrganizations({
    required OrganizationListingRequest request,
  });

  Future<Organization> getOrganizationById({required String id});

  Future<OrganizationMembership> createBuyerOrganization({
    required OrganizationRegistrationRequest request,
  });

  Future<void> createSellerApplication({
    required OrganizationRegistrationRequest request,
  });
}
