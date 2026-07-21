import '../../permission/permission_service.dart';
import 'remote_notification_service.dart';

class OneSignalNotificationService implements RemoteNotificationService {
  final PermissionService permissionService;

  OneSignalNotificationService({required this.permissionService});

  @override
  Future<void> initialize() async {


  }

  @override
  Future<void> login({required String id}) async{

  }

  @override
  Future<void> clearAllNotifications() async {

  }
}
