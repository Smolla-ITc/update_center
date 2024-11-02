import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/config.dart';

/// Notification IDs
const int downloadNotificationId = 1000;
const int downloadCompleteId = 2000;
const int downloadFailedId = 3000;

class NotificationProvider {
  final UpdateCenterConfig config;
  static final _plugin = FlutterLocalNotificationsPlugin();

  const NotificationProvider({required this.config});

  Future<void> initialize() async {
    var settings = InitializationSettings(
      android: AndroidInitializationSettings(config.notificationConfig.defaultIcon),
    );
    await _plugin.initialize(settings);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    NotificationDetails? details,
  }) async {
    await _plugin.show(id, title, body, details);
  }

  Future<void> showDownloadProgress(int maxProgress, int progress, String versionName) async {
    var androidDetails = AndroidNotificationDetails(
      'UpdateCenter',
      'Update Center',
      subText: versionName,
      channelShowBadge: config.notificationConfig.channelShowBadge,
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: config.notificationConfig.showProgress,
      maxProgress: maxProgress,
      progress: progress,
    );
    await showNotification(
      id: downloadNotificationId,
      title: config.notificationConfig.downloadProgressNotificationTextTitle,
      body: config.notificationConfig.downloadProgressNotificationTextBody,
      details: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showGenericNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    var androidDetails = AndroidNotificationDetails(
      'UpdateCenter',
      'Update Center',
      channelShowBadge: true,
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
    );
    await showNotification(id: id, title: title, body: body, details: NotificationDetails(android: androidDetails));
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
