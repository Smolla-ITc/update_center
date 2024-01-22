import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/config.dart';

class NotificationProvider {
  final UpdateCenterConfig config;

  const NotificationProvider({
    required this.config,
  });

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Future method

  Future<void> initialize() async {
    await _initialize(config.defaultIcon);
  }

  Future<void> showDownloadProgressNotification(
      int maxProgress, int progress, String versionName) async {
    await _showDownloadProgressNotification(
      maxProgress,
      progress,
      versionName,
      config.downloadProgressNotificationTextTitle,
      config.downloadProgressNotificationTextBody,
      config.showProgress,
      config.channelShowBadge,
    );
  }

  Future<void> showDownloadFailedNotification(String versionName) async {
    await _showDownloadFailedNotification(
        versionName,
        config.downloadFailedNotificationTitleText,
        config.downloadFailedNotificationBodyText);
  }

  Future<void> cancelNotification(int id) async {
    await _cancelNotification(id);
  }

  /// Static method
  static Future<void> _initialize(String defaultIcon) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings(defaultIcon);
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> _showDownloadProgressNotification(
    int maxProgress,
    int progress,
    String versionName,
    String downloadProgressNotificationTextTitle,
    String downloadProgressNotificationTextBody,
    bool showProgress,
    bool channelShowBadge,
  ) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'UpdateCenter',
      'Update Center',
      channelShowBadge: channelShowBadge,
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: showProgress,
      maxProgress: maxProgress,
      progress: progress,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      900, // Notification ID
      '$downloadProgressNotificationTextTitle $versionName', // Title
      downloadProgressNotificationTextBody, // Body
      platformChannelSpecifics,
      payload: 'download_payload',
    );
  }

  static Future<void> _showDownloadFailedNotification(
    String versionName,
    String downloadFailedNotificationTitleText,
    String downloadFailedNotificationBodyText,
  ) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'UpdateCenter',
      'Update Center',
      channelShowBadge: true,
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      1000, // Notification ID
      downloadFailedNotificationTitleText, // Title
      downloadFailedNotificationBodyText, // Body
      platformChannelSpecifics,
      payload: 'download_failed_payload',
    );
  }

  static Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
