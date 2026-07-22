import '../services/connectivity/connectivity_service.dart';
import '../services/ip/ip_service.dart';
import '../services/notification/remote_notification/one_signal_notification_service.dart';
import '../services/notification/remote_notification/remote_notification_service.dart';
import '../services/permission/permission_service.dart';
import '../services/secure_storage/flutter_secure_storage_service.dart';
import '../services/secure_storage/secure_storage_service.dart';
import '../services/upgrader/upgrader_service.dart';
import 'service_locator.dart';

class AppServices {
  static Future<void> initialize() async {
    getIt.registerSingleton<SecureStorageService>(
      FlutterSecureStorageService(),
    );
    getIt.registerSingleton<PermissionService>(PermissionHandler());
    getIt.registerSingleton<RemoteNotificationService>(
      OneSignalNotificationService(permissionService: getIt())..initialize(),
    );

    await Future.wait([
      getIt
          .registerSingleton<ConnectivityService>(AppConnectivityService())
          .initialize(),
      getIt.registerSingleton<IpService>(IpService()).initialize(),
      getIt
          .registerSingleton<UpgraderService>(AppUpgraderService())
          .initialize(),
    ]);
  }
}
