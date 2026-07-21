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
import '../../presentation/pages/splash/splash_initial_params.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../service_locator/service_locator.dart';
import '../navigation/app_navigator.dart';

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
        builder: (context, state) {
          return SplashPage(
            cubit: getIt(),
            initialParams: SplashInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: LoginPage.path,
        builder: (context, state) {
          return LoginPage(
            cubit: getIt(),
            initialParams: LoginInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: ChooseRolePage.path,
        builder: (context, state) {
          return ChooseRolePage(
            cubit: getIt(),
            initialParams: ChooseRoleInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: PhoneLoginPage.path,
        builder: (context, state) {
          return PhoneLoginPage(
            cubit: getIt(),
            initialParams: PhoneLoginInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: OtpVerificationPage.path,
        builder: (context, state) {
          return OtpVerificationPage(
            cubit: getIt(),
            initialParams: OtpVerificationInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: BuyerRegistrationPage.path,
        builder: (context, state) {
          return BuyerRegistrationPage(
            cubit: getIt(),
            initialParams: BuyerRegistrationInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: SellerRegistrationPage.path,
        builder: (context, state) {
          return SellerRegistrationPage(
            cubit: getIt(),
            initialParams: SellerRegistrationInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: ApplicationReceivedPage.path,
        builder: (context, state) {
          return ApplicationReceivedPage(
            cubit: getIt(),
            initialParams: ApplicationReceivedInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
      GoRoute(
        path: CreateAccountPage.path,
        builder: (context, state) {
          return CreateAccountPage(
            cubit: getIt(),
            initialParams: CreateAccountInitialParams.fromMap(
              state.uri.queryParameters,
            ),
          );
        },
      ),
    ],
  );
}
