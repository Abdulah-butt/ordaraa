import '../../../network/request_model/organization_registration_request.dart';
import '../../../network/request_model/organization_listing_request.dart';
import '../../../network/request_model/product_listing_request.dart';
import '../../../network/request_model/request_phone_otp_request.dart';
import '../../../network/request_model/verify_phone_otp_request.dart';
import '../../../network/request_model/checkout_request.dart';
import '../../../network/request_model/order_listing_request.dart';
import '../../../network/request_model/update_organization_profile_request.dart';
import '../../../network/request_model/update_user_profile_request.dart';
import '../../../core/enums/address_type.dart';

import '../../entities/auth_result.dart';
import '../../entities/category.dart';
import '../../entities/market.dart';
import '../../entities/organization_membership.dart';
import '../../entities/organization.dart';
import '../../entities/paginated_result.dart';
import '../../entities/product.dart';
import '../../entities/address.dart';
import '../../entities/checkout_preview.dart';
import '../../entities/order.dart';
import '../../entities/user.dart';

abstract class RemoteDatabaseRepository {
  Future<void> requestPhoneOtp({required RequestPhoneOtpRequest request});

  Future<AuthResult> verifyPhoneOtp({required VerifyPhoneOtpRequest request});

  Future<AuthResult> getUserProfile();

  Future<User> updateUserProfile({required UpdateUserProfileRequest request});

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

  Future<Organization> getCurrentOrganization();

  Future<Organization> updateCurrentOrganization({
    required UpdateOrganizationProfileRequest request,
  });

  Future<List<Address>> getAddresses({AddressType? type});

  Future<CheckoutPreview> previewCheckout({required CheckoutRequest request});

  Future<Order> placeOrder({
    required CheckoutRequest request,
    required String idempotencyKey,
  });

  Future<Order> getOrderById({required String id});

  Future<PaginatedResult<Order>> getOrders({
    required OrderListingRequest request,
  });

  Future<OrganizationMembership> createBuyerOrganization({
    required OrganizationRegistrationRequest request,
  });

  Future<void> createSellerApplication({
    required OrganizationRegistrationRequest request,
  });
}
