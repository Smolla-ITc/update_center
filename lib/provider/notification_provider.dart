import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/config.dart';

/// NotificationProvider manages the creation and control of notifications for the Update Center.
class NotificationProvider {
  /// Configuration for the Update Center.
  final UpdateCenterConfig config;

  /// Constructor for NotificationProvider requiring the Update Center configuration.
  const NotificationProvider({
    required this.config,
  });

  /// Singleton instance of FlutterLocalNotificationsPlugin.
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification settings.
  ///
  /// It configures the notification's appearance and behavior based on the provided configuration.
  Future<void> initialize() async {
    await _initialize(config.defaultIcon);
  }

  /// Displays a notification showing the download progress.
  ///
  /// [maxProgress] - Maximum value for the progress.
  /// [progress] - Current value for the progress.
  /// [versionName] - Name of the version being downloaded.
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

  /// Displays a notification indicating that the download has failed.
  ///
  /// [versionName] - Name of the version for which the download failed.
  Future<void> showDownloadFailedNotification(String versionName) async {
    await _showDownloadFailedNotification(
        versionName,
        config.downloadFailedNotificationTitleText,
        config.downloadFailedNotificationBodyText);
  }

  /// Cancels a notification with the given [id].
  Future<void> cancelNotification(int id) async {
    await _cancelNotification(id);
  }

  // Private method to initialize the notification plugin with settings.
  static Future<void> _initialize(String defaultIcon) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings(defaultIcon);
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Private method to show a download progress notification.
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
      subText: versionName,
      showProgress: showProgress,
      maxProgress: maxProgress,
      progress: progress,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      900, // Notification ID
      downloadProgressNotificationTextTitle, // Title
      downloadProgressNotificationTextBody, // Body
      platformChannelSpecifics,
      payload: 'download_payload',
    );
  }

  // Private method to show a download failed notification.
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

  // Private method to cancel a notification.
  static Future<void> _cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
