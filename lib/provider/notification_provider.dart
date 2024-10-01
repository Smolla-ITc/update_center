import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/config.dart';

/// Notification IDs
///
/// 1000: Download notification
/// 2000: Download complete
/// 3000: Download failed

class NotificationProvider {
  final UpdateCenterConfig config;

  const NotificationProvider({
    required this.config,
  });

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize notification plugin
  Future<void> initialize() async {
    var initializationSettingsAndroid =
    AndroidInitializationSettings(config.notificationConfig.defaultIcon);
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Show notification with optional progress
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? versionName,
    bool showProgress = false,
    int maxProgress = 0,
    int progress = 0,
    bool isLowImportance = true,
    bool channelShowBadge = true,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'UpdateCenter',
      'Update Center',
      subText: versionName,
      channelShowBadge: channelShowBadge,
      importance: isLowImportance ? Importance.low : Importance.high,
      priority: isLowImportance ? Priority.low : Priority.high,
      onlyAlertOnce: true,
      showProgress: showProgress,
      maxProgress: showProgress ? maxProgress : 0,
      progress: showProgress ? progress : 0,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  /// Show a download progress notification
  Future<void> showDownloadProgress({
    required int maxProgress,
    required int progress,
    required String versionName,
  }) async {
    await showNotification(
      id: 1000,
      title: config.notificationConfig.downloadProgressNotificationTextTitle,
      body: config.notificationConfig.downloadProgressNotificationTextBody,
      versionName: versionName,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
    );
  }

  /// Show a generic notification (e.g., download failed, complete)
  Future<void> showGenericNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await showNotification(
      id: id,
      title: title,
      body: body,
      showProgress: false,
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
