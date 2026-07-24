import 'package:get_it/get_it.dart';
import '../core/alert/app_snack_bar.dart';
import '../core/navigation/app_navigator.dart';
import '../core/routes/app_router.dart';
import '../data/repositories/database/hive_database_imp.dart';
import '../data/repositories/database/remote_database_imp.dart';
import '../domain/repositories/database/local_database_repository.dart';
import '../domain/repositories/database/remote_database_repository.dart';
import '../domain/stores/user_store.dart';
import '../domain/stores/category_store.dart';
import '../domain/stores/cart_store.dart';
import '../domain/stores/market_store.dart';
import '../domain/usecases/add_to_cart_use_case.dart';
import '../domain/usecases/add_address_use_case.dart';
import '../domain/usecases/update_address_use_case.dart';
import '../domain/usecases/delete_address_use_case.dart';
import '../domain/usecases/get_addresses_use_case.dart';
import '../domain/usecases/get_order_by_id_use_case.dart';
import '../domain/usecases/get_orders_use_case.dart';
import '../domain/usecases/place_order_use_case.dart';
import '../domain/usecases/preview_checkout_use_case.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/get_product_listings_use_case.dart';
import '../domain/usecases/get_organizations_use_case.dart';
import '../domain/usecases/get_product_by_id_use_case.dart';
import '../domain/usecases/get_organization_by_id_use_case.dart';
import '../domain/usecases/get_current_organization_use_case.dart';
import '../domain/usecases/update_organization_profile_use_case.dart';
import '../domain/usecases/update_user_profile_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/request_phone_otp_use_case.dart';
import '../domain/usecases/resolve_auth_flow_destination_use_case.dart';
import '../domain/usecases/register_buyer_organization_use_case.dart';
import '../domain/usecases/signup_use_case.dart';
import '../domain/usecases/user_login_session_use_case.dart';
import '../domain/usecases/verify_phone_otp_use_case.dart';
import '../network/dio/dio_network_repository.dart';
import '../network/network_repository.dart';
import '../presentation/pages/splash/splash_page.dart';
import 'app_cubits.dart';
import 'app_services.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> initialize() async {
    getIt.registerSingleton<AppSnackBar>(AppSnackBar());
    getIt.registerSingleton<AppNavigator>(AppNavigator());

    /// services
    ///
    ///
    await AppServices.initialize();

    /// repositories
    ///
    ///
    await getIt
        .registerSingleton<LocalDatabaseRepository>(HiveDatabaseImp())
        .initialize();

    getIt.registerSingleton<UserStore>(UserStore());
    getIt.registerSingleton<CartStore>(CartStore());
    getIt.registerSingleton<LogoutUseCase>(
      LogoutUseCase(getIt(), getIt(), getIt()),
    );

    getIt.registerSingleton<NetworkRepository>(
      DioNetworkRepository(
        getIt(),
        getIt(),
        onSessionExpired: () async {
          try {
            await getIt<LogoutUseCase>().execute();
          } finally {
            AppRouter.router.go(SplashPage.path);
          }
        },
      ),
    );
    getIt.registerSingleton<RemoteDatabaseRepository>(
      RemoteDatabaseImp(getIt()),
    );

    /// stores
    ///
    ///
    getIt.registerSingleton<MarketStore>(MarketStore(getIt()));
    getIt.registerSingleton<CategoryStore>(CategoryStore(getIt()));

    /// use_cases
    ///
    ///
    ///
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(getIt(), getIt(), getIt()),
    );
    getIt.registerSingleton<SignupUseCase>(
      SignupUseCase(getIt(), getIt(), getIt()),
    );
    getIt.registerSingleton<ResolveAuthFlowDestinationUseCase>(
      ResolveAuthFlowDestinationUseCase(getIt(), getIt()),
    );
    getIt.registerSingleton<UserLoginSessionUseCase>(
      UserLoginSessionUseCase(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerSingleton<RequestPhoneOtpUseCase>(
      RequestPhoneOtpUseCase(getIt()),
    );
    getIt.registerSingleton<GetProductListingsUseCase>(
      GetProductListingsUseCase(getIt()),
    );
    getIt.registerSingleton<GetOrganizationsUseCase>(
      GetOrganizationsUseCase(getIt()),
    );
    getIt.registerSingleton<GetProductByIdUseCase>(
      GetProductByIdUseCase(getIt()),
    );
    getIt.registerSingleton<GetOrganizationByIdUseCase>(
      GetOrganizationByIdUseCase(getIt()),
    );
    getIt.registerSingleton<GetCurrentOrganizationUseCase>(
      GetCurrentOrganizationUseCase(getIt()),
    );
    getIt.registerSingleton<UpdateOrganizationProfileUseCase>(
      UpdateOrganizationProfileUseCase(getIt(), getIt()),
    );
    getIt.registerSingleton<UpdateUserProfileUseCase>(
      UpdateUserProfileUseCase(getIt(), getIt()),
    );
    getIt.registerSingleton<AddToCartUseCase>(AddToCartUseCase(getIt()));
    getIt.registerSingleton<GetAddressesUseCase>(GetAddressesUseCase(getIt()));
    getIt.registerSingleton<AddAddressUseCase>(AddAddressUseCase(getIt()));
    getIt.registerSingleton<UpdateAddressUseCase>(
      UpdateAddressUseCase(getIt()),
    );
    getIt.registerSingleton<DeleteAddressUseCase>(
      DeleteAddressUseCase(getIt()),
    );
    getIt.registerSingleton<GetOrdersUseCase>(GetOrdersUseCase(getIt()));
    getIt.registerSingleton<PreviewCheckoutUseCase>(
      PreviewCheckoutUseCase(getIt()),
    );
    getIt.registerSingleton<PlaceOrderUseCase>(PlaceOrderUseCase(getIt()));
    getIt.registerSingleton<GetOrderByIdUseCase>(GetOrderByIdUseCase(getIt()));
    getIt.registerSingleton<RegisterBuyerOrganizationUseCase>(
      RegisterBuyerOrganizationUseCase(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerSingleton<VerifyPhoneOtpUseCase>(
      VerifyPhoneOtpUseCase(getIt(), getIt(), getIt(), getIt()),
    );
    await AppCubits.initialize();
  }
}
