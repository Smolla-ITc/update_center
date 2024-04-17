import '../utils/constants.dart';

/// Global Configuration for the plugin
class GlobalConfig {
  final bool isCheckStart;
  final bool isNoUpdateAvailableToast;
  final bool isSourceUrl;
  final bool isRequestForNotifications;
  final bool isOpenFile;
  final AndroidDialogBuilder? androidDialogBuilder;
  final IOSDialogBuilder? iosDialogBuilder;
  final WindowsDialogBuilder? windowsDialogBuilder;

  final NoUpdateAvailableBuilder? androidNoUpdateAvailableBuilder;
  final NoUpdateAvailableBuilder? iosNoUpdateAvailableBuilder;
  final NoUpdateAvailableBuilder? windowsNoUpdateAvailableBuilder;
  GlobalConfig({
    this.isCheckStart = false,
    this.isNoUpdateAvailableToast = false,
    this.isSourceUrl = false,
    this.isRequestForNotifications = false,
    this.isOpenFile = false,
    this.androidDialogBuilder,
    this.iosDialogBuilder,
    this.windowsDialogBuilder,
    this.androidNoUpdateAvailableBuilder,
    this.iosNoUpdateAvailableBuilder,
    this.windowsNoUpdateAvailableBuilder,
  });
}

/// Notification Configuration
class NotificationConfig {
  final String defaultIcon;
  final String downloadProgressNotificationTextTitle;
  final String downloadProgressNotificationTextBody;
  final String downloadFailedNotificationTitleText;
  final String downloadFailedNotificationBodyText;
  final bool showProgress;
  final bool channelShowBadge;

  NotificationConfig({
    this.defaultIcon = '@mipmap/ic_launcher',
    this.downloadProgressNotificationTextTitle = 'Download',
    this.downloadProgressNotificationTextBody = '',
    this.downloadFailedNotificationTitleText = 'Download failed',
    this.downloadFailedNotificationBodyText =
        'An error occurred while downloading update. Check your internet connections and try again',
    this.showProgress = true,
    this.channelShowBadge = true,
  });
}

/// Config for the plugin
class UpdateCenterConfig {
  final GlobalConfig globalConfig;
  final NotificationConfig notificationConfig;

  UpdateCenterConfig({
    required this.globalConfig,
    required this.notificationConfig,
  });
}
