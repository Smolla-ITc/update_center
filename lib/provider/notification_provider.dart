import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/config.dart';


/// id notification
///
/// 1000 Download notification
/// 2000 Download complete
/// 3000 Download failed
/// 4000 Verified sha256



/// The notification provider stores all the methods for displaying notifications to make them easier to manage.
class NotificationProvider {
  final UpdateCenterConfig config;

  const NotificationProvider({
    required this.config,
  });

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final int downloadIdNotification = 1000;
  final int downloadIdN = 1000;

  /// Initializing the notification plugin
  Future<void> initialize() async {
    var initializationSettingsAndroid = AndroidInitializationSettings(config.notificationConfig.defaultIcon);
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required NotificationDetails platformChannelSpecifics,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id, // Notification ID
      title, // Title
      body, // Body
      platformChannelSpecifics,
    );
  }

 /// Separate code to show file download progress
  Future<void> showDownloadProgressNotification(int maxProgress, int progress, String versionName) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'UpdateCenter',
      'Update Center',
      subText: versionName,
      channelShowBadge: config.notificationConfig.channelShowBadge,
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: false,
      showProgress: config.notificationConfig.showProgress,
      maxProgress: maxProgress,
      progress: progress,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await showNotification(
      id: 1000,
      title: config.notificationConfig.downloadProgressNotificationTextTitle,
      body: config.notificationConfig.downloadProgressNotificationTextBody,
      platformChannelSpecifics: platformChannelSpecifics,

    );
  }

 /// Universal code for notifications that is used throughout the plugin
  Future<void> showGenericNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'UpdateCenter',
      'Update Center',
      channelShowBadge: true,
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: false,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await showNotification(
      id: id,
      title: title,
      body: body,
      platformChannelSpecifics: platformChannelSpecifics,
    );
  }

  /// Code to cancel notifications
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
