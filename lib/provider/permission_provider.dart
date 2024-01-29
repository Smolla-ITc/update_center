import 'package:permission_handler/permission_handler.dart';

/// Provider for different requests
class PermissionProvider {
  /// Makes a request to show notifications
  static Future<void> requestForNotifications() async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }
}
