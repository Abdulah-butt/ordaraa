class APIEndpoint {
  static const String requestPhoneOtp = '/api/v1/auth/phone/request-otp';
  static const String verifyPhoneOtp = '/api/v1/auth/phone/verify-otp';
  static const String refreshAuthSession = '/api/v1/auth/refresh';
  static const String markets = '/api/v1/markets';
  static const String categories = '/api/v1/categories';
  static const String listings = '/api/v1/listings';
  static const String organizations = '/api/v1/organizations';
  static String listingById(String id) => '$listings/$id';
  static String organizationById(String id) => '$organizations/$id';
  static const String createBuyerOrganization = '/api/v1/organizations';
  static const String createSellerApplication = '/api/v1/seller-applications';
  static const String currentOrganization = '/api/v1/organizations/current';
  static const String organizationAddresses = '$currentOrganization/addresses';
  static const String checkoutPreview = '$currentOrganization/checkout/preview';
  static const String orders = '$currentOrganization/orders';
  static String orderById(String id) => '$orders/$id';

  static const String login = "/api/auth/login";
  static const String createAccount = "/api/auth/create_account";

  static const String getProfile = "/api/v1/auth/me";
}
