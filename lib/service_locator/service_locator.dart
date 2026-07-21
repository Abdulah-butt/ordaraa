import 'package:get_it/get_it.dart';
import '../core/alert/app_snack_bar.dart';
import '../core/navigation/app_navigator.dart';
import '../data/repositories/database/hive_database_imp.dart';
import '../data/repositories/database/remote_database_imp.dart';
import '../domain/repositories/database/local_database_repository.dart';
import '../domain/repositories/database/remote_database_repository.dart';
import '../domain/stores/user_store.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/signup_use_case.dart';
import '../domain/usecases/user_login_session_use_case.dart';
import '../network/dio/dio_network_repository.dart';
import '../network/network_repository.dart';
import 'app_cubits.dart';
import 'app_services.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static initialize() async {
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
    getIt.registerSingleton<NetworkRepository>(DioNetworkRepository(getIt()));
    getIt.registerSingleton<RemoteDatabaseRepository>(
        RemoteDatabaseImp(getIt()));

    /// stores
    ///
    ///
    getIt.registerSingleton<UserStore>(UserStore());

    /// use_cases
    ///
    ///
    ///
    getIt.registerSingleton<LoginUseCase>(
      LoginUseCase(
        getIt(),
        getIt(),
        getIt(),
      ),
    );
    getIt.registerSingleton<SignupUseCase>(
      SignupUseCase(getIt(), getIt(), getIt()),
    );
    getIt.registerSingleton<LogoutUseCase>(
      LogoutUseCase(
        getIt(),
        getIt(),
      ),
    );

    getIt.registerSingleton<UserLoginSessionUseCase>(
      UserLoginSessionUseCase(getIt(), getIt(), getIt()),
    );
    await AppCubits.initialize();
  }
}
