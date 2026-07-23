import 'package:get_it/get_it.dart';
import '../core/alert/app_snack_bar.dart';
import '../core/navigation/app_navigator.dart';
import '../data/repositories/database/hive_database_imp.dart';
import '../data/repositories/database/remote_database_imp.dart';
import '../domain/repositories/database/local_database_repository.dart';
import '../domain/repositories/database/remote_database_repository.dart';
import '../domain/stores/user_store.dart';
import '../domain/stores/category_store.dart';
import '../domain/stores/cart_store.dart';
import '../domain/stores/market_store.dart';
import '../domain/usecases/add_to_cart_use_case.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/get_product_listings_use_case.dart';
import '../domain/usecases/get_organizations_use_case.dart';
import '../domain/usecases/get_product_by_id_use_case.dart';
import '../domain/usecases/get_organization_by_id_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/request_phone_otp_use_case.dart';
import '../domain/usecases/register_buyer_organization_use_case.dart';
import '../domain/usecases/signup_use_case.dart';
import '../domain/usecases/user_login_session_use_case.dart';
import '../domain/usecases/verify_phone_otp_use_case.dart';
import '../network/dio/dio_network_repository.dart';
import '../network/network_repository.dart';
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
    getIt.registerSingleton<NetworkRepository>(
      DioNetworkRepository(getIt(), getIt()),
    );
    getIt.registerSingleton<RemoteDatabaseRepository>(
      RemoteDatabaseImp(getIt()),
    );

    /// stores
    ///
    ///
    getIt.registerSingleton<UserStore>(UserStore());
    getIt.registerSingleton<MarketStore>(MarketStore(getIt()));
    getIt.registerSingleton<CategoryStore>(CategoryStore(getIt()));
    getIt.registerSingleton<CartStore>(CartStore());

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
    getIt.registerSingleton<LogoutUseCase>(
      LogoutUseCase(getIt(), getIt(), getIt()),
    );

    getIt.registerSingleton<UserLoginSessionUseCase>(
      UserLoginSessionUseCase(getIt(), getIt(), getIt()),
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
    getIt.registerSingleton<AddToCartUseCase>(AddToCartUseCase(getIt()));
    getIt.registerSingleton<RegisterBuyerOrganizationUseCase>(
      RegisterBuyerOrganizationUseCase(getIt(), getIt(), getIt()),
    );
    getIt.registerSingleton<VerifyPhoneOtpUseCase>(
      VerifyPhoneOtpUseCase(getIt(), getIt(), getIt(), getIt()),
    );
    await AppCubits.initialize();
  }
}
