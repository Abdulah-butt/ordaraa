import '../presentation/pages/authentication/create_account/create_account_cubit.dart';
import '../presentation/pages/authentication/create_account/create_account_navigator.dart';
import '../presentation/pages/authentication/buyer_registration/buyer_registration_cubit.dart';
import '../presentation/pages/authentication/buyer_registration/buyer_registration_navigator.dart';
import '../presentation/pages/authentication/login/login_cubit.dart';
import '../presentation/pages/authentication/login/login_navigator.dart';
import '../presentation/pages/authentication/otp_verification/otp_verification_cubit.dart';
import '../presentation/pages/authentication/otp_verification/otp_verification_navigator.dart';
import '../presentation/pages/authentication/phone_login/phone_login_cubit.dart';
import '../presentation/pages/authentication/phone_login/phone_login_navigator.dart';
import '../presentation/pages/authentication/seller_registration/application_received/application_received_cubit.dart';
import '../presentation/pages/authentication/seller_registration/application_received/application_received_navigator.dart';
import '../presentation/pages/authentication/seller_registration/seller_registration_cubit.dart';
import '../presentation/pages/authentication/seller_registration/seller_registration_navigator.dart';
import '../presentation/pages/choose_role/choose_role_cubit.dart';
import '../presentation/pages/choose_role/choose_role_navigator.dart';
import '../presentation/pages/buyer/account/buyer_account_cubit.dart';
import '../presentation/pages/buyer/account/buyer_account_navigator.dart';
import '../presentation/pages/common/organization_profile/organization_profile_cubit.dart';
import '../presentation/pages/common/organization_profile/organization_profile_navigator.dart';
import '../presentation/pages/common/personal_profile/personal_profile_cubit.dart';
import '../presentation/pages/common/personal_profile/personal_profile_navigator.dart';
import '../presentation/pages/common/saved_addresses/saved_addresses_cubit.dart';
import '../presentation/pages/common/saved_addresses/saved_addresses_navigator.dart';
import '../presentation/pages/buyer/categories/buyer_categories_cubit.dart';
import '../presentation/pages/buyer/categories/buyer_categories_navigator.dart';
import '../presentation/pages/buyer/cart/cart_cubit.dart';
import '../presentation/pages/buyer/cart/cart_navigator.dart';
import '../presentation/pages/buyer/checkout/checkout_cubit.dart';
import '../presentation/pages/buyer/checkout/checkout_navigator.dart';
import '../presentation/pages/buyer/order_confirmed/order_confirmed_cubit.dart';
import '../presentation/pages/buyer/order_confirmed/order_confirmed_navigator.dart';
import '../presentation/pages/buyer/home/buyer_home_cubit.dart';
import '../presentation/pages/buyer/home/buyer_home_navigator.dart';
import '../presentation/pages/buyer/orders/buyer_orders_cubit.dart';
import '../presentation/pages/buyer/orders/buyer_orders_navigator.dart';
import '../presentation/pages/buyer/order_detail/order_detail_cubit.dart';
import '../presentation/pages/buyer/order_detail/order_detail_navigator.dart';
import '../presentation/pages/buyer/product_detail/product_detail_cubit.dart';
import '../presentation/pages/buyer/product_detail/product_detail_navigator.dart';
import '../presentation/pages/buyer/search/buyer_search_cubit.dart';
import '../presentation/pages/buyer/search/buyer_search_navigator.dart';
import '../presentation/pages/buyer/seller_detail/seller_detail_cubit.dart';
import '../presentation/pages/buyer/seller_detail/seller_detail_navigator.dart';
import '../presentation/pages/splash/splash_cubit.dart';
import '../presentation/pages/splash/splash_navigator.dart';
import 'service_locator.dart';

/*
     ==============================================================
     THIS CLASS WITH REGISTER SCREENS CUBITS AND NAVIGATORS
      -> NAVIGATORS WILL BE USED FOR NAVIGATION TO OTHER SCREEN
      -> CUBIT WILL BE USED FOR EVENT HANDLING OR BUSINESS LOGIC
      -> BOTH ARE REGISTERED IN GET-IT TO KEEP MEMORY OPTIMIZATION AND SERVICE LOCATOR
     ==============================================================
   */

class AppCubits {
  static Future<void> initialize() async {
    /// authentication Cubits + navigators
    getIt.registerSingleton<CreateAccountNavigator>(
      CreateAccountNavigator(getIt()),
    );
    getIt.registerSingleton<CreateAccountCubit>(
      CreateAccountCubit(
        navigator: getIt(),
        signupUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<LoginNavigator>(LoginNavigator(getIt()));
    getIt.registerSingleton<LoginCubit>(
      LoginCubit(navigator: getIt(), loginUseCase: getIt(), snackBar: getIt()),
    );

    /// splash screen Cubit + navigator
    getIt.registerSingleton<SplashNavigator>(SplashNavigator(getIt()));
    getIt.registerSingleton<SplashCubit>(
      SplashCubit(navigator: getIt(), userLoginSessionUseCase: getIt()),
    );
    getIt.registerSingleton<ChooseRoleNavigator>(ChooseRoleNavigator(getIt()));
    getIt.registerSingleton<ChooseRoleCubit>(
      ChooseRoleCubit(navigator: getIt()),
    );

    /// WhatsApp authentication Cubits + navigators
    getIt.registerSingleton<PhoneLoginNavigator>(PhoneLoginNavigator(getIt()));
    getIt.registerSingleton<PhoneLoginCubit>(
      PhoneLoginCubit(
        navigator: getIt(),
        snackBar: getIt(),
        requestPhoneOtpUseCase: getIt(),
      ),
    );
    getIt.registerSingleton<OtpVerificationNavigator>(
      OtpVerificationNavigator(getIt()),
    );
    getIt.registerSingleton<OtpVerificationCubit>(
      OtpVerificationCubit(
        navigator: getIt(),
        snackBar: getIt(),
        requestPhoneOtpUseCase: getIt(),
        verifyPhoneOtpUseCase: getIt(),
      ),
    );

    /// buyer and seller registration Cubits + navigators
    getIt.registerSingleton<BuyerRegistrationNavigator>(
      BuyerRegistrationNavigator(getIt()),
    );
    getIt.registerSingleton<BuyerRegistrationCubit>(
      BuyerRegistrationCubit(
        navigator: getIt(),
        snackBar: getIt(),
        marketStore: getIt(),
        userStore: getIt(),
        registerBuyerOrganizationUseCase: getIt(),
      ),
    );
    getIt.registerSingleton<SellerRegistrationNavigator>(
      SellerRegistrationNavigator(getIt()),
    );
    getIt.registerSingleton<SellerRegistrationCubit>(
      SellerRegistrationCubit(
        navigator: getIt(),
        snackBar: getIt(),
        marketStore: getIt(),
      ),
    );
    getIt.registerSingleton<ApplicationReceivedNavigator>(
      ApplicationReceivedNavigator(getIt()),
    );
    getIt.registerSingleton<ApplicationReceivedCubit>(
      ApplicationReceivedCubit(navigator: getIt(), snackBar: getIt()),
    );

    /// buyer app Cubits + navigators
    getIt.registerSingleton<BuyerHomeNavigator>(BuyerHomeNavigator(getIt()));
    getIt.registerSingleton<BuyerHomeCubit>(
      BuyerHomeCubit(
        navigator: getIt(),
        categoryStore: getIt(),
        snackBar: getIt(),
        getProductListingsUseCase: getIt(),
        getOrganizationsUseCase: getIt(),
        addToCartUseCase: getIt(),
      ),
    );
    getIt.registerSingleton<CartNavigator>(CartNavigator(getIt()));
    getIt.registerSingleton<CartCubit>(
      CartCubit(navigator: getIt(), cartStore: getIt(), snackBar: getIt()),
    );
    getIt.registerSingleton<CheckoutNavigator>(CheckoutNavigator(getIt()));
    getIt.registerSingleton<CheckoutCubit>(
      CheckoutCubit(
        navigator: getIt(),
        cartStore: getIt(),
        getAddressesUseCase: getIt(),
        previewCheckoutUseCase: getIt(),
        placeOrderUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<OrderConfirmedNavigator>(
      OrderConfirmedNavigator(getIt()),
    );
    getIt.registerSingleton<OrderConfirmedCubit>(
      OrderConfirmedCubit(navigator: getIt(), getOrderByIdUseCase: getIt()),
    );
    getIt.registerSingleton<OrderDetailNavigator>(
      OrderDetailNavigator(getIt()),
    );
    getIt.registerSingleton<OrderDetailCubit>(
      OrderDetailCubit(
        navigator: getIt(),
        getOrderByIdUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<BuyerCategoriesNavigator>(
      BuyerCategoriesNavigator(getIt()),
    );
    getIt.registerSingleton<BuyerCategoriesCubit>(
      BuyerCategoriesCubit(
        navigator: getIt(),
        categoryStore: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<BuyerSearchNavigator>(
      BuyerSearchNavigator(getIt()),
    );
    getIt.registerSingleton<BuyerSearchCubit>(
      BuyerSearchCubit(
        navigator: getIt(),
        categoryStore: getIt(),
        getProductListingsUseCase: getIt(),
        getOrganizationsUseCase: getIt(),
        addToCartUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<ProductDetailNavigator>(
      ProductDetailNavigator(getIt()),
    );
    getIt.registerSingleton<ProductDetailCubit>(
      ProductDetailCubit(
        navigator: getIt(),
        getProductByIdUseCase: getIt(),
        addToCartUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<SellerDetailNavigator>(
      SellerDetailNavigator(getIt()),
    );
    getIt.registerSingleton<SellerDetailCubit>(
      SellerDetailCubit(
        navigator: getIt(),
        getOrganizationByIdUseCase: getIt(),
        getProductListingsUseCase: getIt(),
        addToCartUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<BuyerOrdersNavigator>(
      BuyerOrdersNavigator(getIt()),
    );
    getIt.registerSingleton<BuyerOrdersCubit>(
      BuyerOrdersCubit(navigator: getIt(), getOrdersUseCase: getIt()),
    );
    getIt.registerSingleton<BuyerAccountNavigator>(
      BuyerAccountNavigator(getIt()),
    );
    getIt.registerSingleton<BuyerAccountCubit>(
      BuyerAccountCubit(
        navigator: getIt(),
        userStore: getIt(),
        logoutUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<OrganizationProfileNavigator>(
      OrganizationProfileNavigator(getIt()),
    );
    getIt.registerSingleton<OrganizationProfileCubit>(
      OrganizationProfileCubit(
        navigator: getIt(),
        getCurrentOrganizationUseCase: getIt(),
        updateOrganizationProfileUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<PersonalProfileNavigator>(
      PersonalProfileNavigator(getIt()),
    );
    getIt.registerSingleton<PersonalProfileCubit>(
      PersonalProfileCubit(
        navigator: getIt(),
        userStore: getIt(),
        updateUserProfileUseCase: getIt(),
        snackBar: getIt(),
      ),
    );
    getIt.registerSingleton<SavedAddressesNavigator>(
      SavedAddressesNavigator(getIt()),
    );
    getIt.registerSingleton<SavedAddressesCubit>(
      SavedAddressesCubit(navigator: getIt(), getAddressesUseCase: getIt()),
    );
  }
}
