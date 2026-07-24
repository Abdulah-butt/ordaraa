import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';
import '../../presentation/pages/authentication/create_account/create_account_initial_params.dart';
import '../../presentation/pages/authentication/create_account/create_account_page.dart';
import '../../presentation/pages/authentication/buyer_registration/buyer_registration_initial_params.dart';
import '../../presentation/pages/authentication/buyer_registration/buyer_registration_page.dart';
import '../../presentation/pages/authentication/login/login_initial_params.dart';
import '../../presentation/pages/authentication/login/login_page.dart';
import '../../presentation/pages/authentication/otp_verification/otp_verification_initial_params.dart';
import '../../presentation/pages/authentication/otp_verification/otp_verification_page.dart';
import '../../presentation/pages/authentication/phone_login/phone_login_initial_params.dart';
import '../../presentation/pages/authentication/phone_login/phone_login_page.dart';
import '../../presentation/pages/authentication/seller_registration/application_received/application_received_initial_params.dart';
import '../../presentation/pages/authentication/seller_registration/application_received/application_received_page.dart';
import '../../presentation/pages/authentication/seller_registration/seller_registration_initial_params.dart';
import '../../presentation/pages/authentication/seller_registration/seller_registration_page.dart';
import '../../presentation/pages/choose_role/choose_role_initial_params.dart';
import '../../presentation/pages/choose_role/choose_role_page.dart';
import '../../presentation/pages/buyer/account/buyer_account_initial_params.dart';
import '../../presentation/pages/buyer/account/buyer_account_page.dart';
import '../../presentation/pages/common/organization_profile/organization_profile_initial_params.dart';
import '../../presentation/pages/common/organization_profile/organization_profile_page.dart';
import '../../presentation/pages/common/personal_profile/personal_profile_initial_params.dart';
import '../../presentation/pages/common/personal_profile/personal_profile_page.dart';
import '../../presentation/pages/common/saved_addresses/saved_addresses_initial_params.dart';
import '../../presentation/pages/common/saved_addresses/saved_addresses_page.dart';
import '../../presentation/pages/common/saved_addresses/add_address/add_address_initial_params.dart';
import '../../presentation/pages/common/saved_addresses/add_address/add_address_page.dart';
import '../../presentation/pages/buyer/bottom_navigation/buyer_bottom_navigation.dart';
import '../../presentation/pages/buyer/categories/buyer_categories_initial_params.dart';
import '../../presentation/pages/buyer/categories/buyer_categories_page.dart';
import '../../presentation/pages/buyer/cart/cart_initial_params.dart';
import '../../presentation/pages/buyer/cart/cart_page.dart';
import '../../presentation/pages/buyer/checkout/checkout_initial_params.dart';
import '../../presentation/pages/buyer/checkout/checkout_page.dart';
import '../../presentation/pages/buyer/order_confirmed/order_confirmed_initial_params.dart';
import '../../presentation/pages/buyer/order_confirmed/order_confirmed_page.dart';
import '../../presentation/pages/buyer/order_detail/order_detail_initial_params.dart';
import '../../presentation/pages/buyer/order_detail/order_detail_page.dart';
import '../../presentation/pages/buyer/home/buyer_home_initial_params.dart';
import '../../presentation/pages/buyer/home/buyer_home_page.dart';
import '../../presentation/pages/buyer/orders/buyer_orders_initial_params.dart';
import '../../presentation/pages/buyer/orders/buyer_orders_page.dart';
import '../../presentation/pages/buyer/product_detail/product_detail_initial_params.dart';
import '../../presentation/pages/buyer/product_detail/product_detail_page.dart';
import '../../presentation/pages/buyer/search/buyer_search_initial_params.dart';
import '../../presentation/pages/buyer/search/buyer_search_page.dart';
import '../../presentation/pages/buyer/seller_detail/seller_detail_initial_params.dart';
import '../../presentation/pages/buyer/seller_detail/seller_detail_page.dart';
import '../../presentation/pages/splash/splash_initial_params.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../service_locator/service_locator.dart';
import '../navigation/app_navigator.dart';
import 'app_route_transition.dart';

final GlobalKey<NavigatorState> _buyerShellNavigator =
    GlobalKey<NavigatorState>(debugLabel: 'buyer_shell');

class AppRouter {
  static void initialize() {
    setPathUrlStrategy();
    GoRouter.optionURLReflectsImperativeAPIs = true;
  }

  static final router = GoRouter(
    navigatorKey: AppNavigator.navigatorKey,
    initialLocation: SplashPage.path,
    routes: [
      GoRoute(
        path: SplashPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: SplashPage(
              cubit: getIt(),
              initialParams: SplashInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: LoginPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: LoginPage(
              cubit: getIt(),
              initialParams: LoginInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: ChooseRolePage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: ChooseRolePage(
              cubit: getIt(),
              initialParams: ChooseRoleInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: PhoneLoginPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: PhoneLoginPage(
              cubit: getIt(),
              initialParams: PhoneLoginInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: OtpVerificationPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: OtpVerificationPage(
              cubit: getIt(),
              initialParams: OtpVerificationInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: BuyerRegistrationPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: BuyerRegistrationPage(
              cubit: getIt(),
              initialParams: BuyerRegistrationInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: SellerRegistrationPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: SellerRegistrationPage(
              cubit: getIt(),
              initialParams: SellerRegistrationInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: ApplicationReceivedPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: ApplicationReceivedPage(
              cubit: getIt(),
              initialParams: ApplicationReceivedInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: CreateAccountPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: CreateAccountPage(
              cubit: getIt(),
              initialParams: CreateAccountInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: ProductDetailPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: ProductDetailPage(
              cubit: getIt(),
              initialParams: ProductDetailInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: OrganizationProfilePage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: OrganizationProfilePage(
              cubit: getIt(),
              initialParams: OrganizationProfileInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: PersonalProfilePage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: PersonalProfilePage(
              cubit: getIt(),
              initialParams: PersonalProfileInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: SavedAddressesPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: SavedAddressesPage(
              cubit: getIt(),
              initialParams: SavedAddressesInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AddAddressPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: AddAddressPage(
              cubit: getIt(),
              initialParams: AddAddressInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: CartPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: CartPage(
              cubit: getIt(),
              initialParams: CartInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: CheckoutPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: CheckoutPage(
              cubit: getIt(),
              initialParams: CheckoutInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: OrderConfirmedPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: OrderConfirmedPage(
              cubit: getIt(),
              initialParams: OrderConfirmedInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: OrderDetailPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: OrderDetailPage(
              cubit: getIt(),
              initialParams: OrderDetailInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: SellerDetailPage.path,
        pageBuilder: (context, state) {
          return AppRouteTransition.build(
            state: state,
            child: SellerDetailPage(
              cubit: getIt(),
              initialParams: SellerDetailInitialParams.fromMap(
                state.uri.queryParameters,
              ),
            ),
          );
        },
      ),
      ShellRoute(
        navigatorKey: _buyerShellNavigator,
        builder: (context, state, child) {
          return BuyerBottomNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: BuyerHomePage.path,
            pageBuilder: (context, state) {
              return AppRouteTransition.build(
                state: state,
                child: BuyerHomePage(
                  cubit: getIt(),
                  initialParams: BuyerHomeInitialParams.fromMap(
                    state.uri.queryParameters,
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: BuyerCategoriesPage.path,
            pageBuilder: (context, state) {
              return AppRouteTransition.build(
                state: state,
                child: BuyerCategoriesPage(
                  cubit: getIt(),
                  initialParams: BuyerCategoriesInitialParams.fromMap(
                    state.uri.queryParameters,
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: BuyerSearchPage.path,
            pageBuilder: (context, state) {
              return AppRouteTransition.build(
                state: state,
                child: BuyerSearchPage(
                  cubit: getIt(),
                  initialParams: BuyerSearchInitialParams.fromMap(
                    state.uri.queryParameters,
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: BuyerOrdersPage.path,
            pageBuilder: (context, state) {
              return AppRouteTransition.build(
                state: state,
                child: BuyerOrdersPage(
                  cubit: getIt(),
                  initialParams: BuyerOrdersInitialParams.fromMap(
                    state.uri.queryParameters,
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: BuyerAccountPage.path,
            pageBuilder: (context, state) {
              return AppRouteTransition.build(
                state: state,
                child: BuyerAccountPage(
                  cubit: getIt(),
                  initialParams: BuyerAccountInitialParams.fromMap(
                    state.uri.queryParameters,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}
