import 'package:permission_handler/permission_handler.dart';

enum PermissionRequest {
  location,
  notification,
}

abstract class PermissionService {
  Future<void> requestPermission(PermissionRequest request);
}




class PermissionHandler implements PermissionService{
  @override
  Future<void> requestPermission(PermissionRequest request) async {
    switch (request) {
      case PermissionRequest.location:
        await _locationPermission();
        break;
      case PermissionRequest.notification:
        await _notificationPermission();
        break;
    }
  }

  _locationPermission() async {
    PermissionStatus status = await Permission.location.request();
    _checkPermissionStatus(status);
  }
  _notificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    _checkPermissionStatus(status);
  }

  void _checkPermissionStatus(PermissionStatus status) {
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.limited ||
        status == PermissionStatus.restricted) {
      throw "Permission denied, enable it from setting";
    }
  }
}


