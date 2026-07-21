abstract class RemoteNotificationService{
  Future<void> initialize();
  Future<void> clearAllNotifications();
  Future<void> login({required String id});
}


