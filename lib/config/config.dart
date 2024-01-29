 import 'package:flutter/material.dart';
 import '../utils/constants.dart';

/// Global Configuration for the plugin
class GlobalConfig {
  final bool isCheckStart;
  final bool isNoUpdateAvailableToast;
  final bool isSourceUrl;
  final bool isVerifiedSha256Android;
  final bool isVerifiedSha256Windows;
  final bool isRequestForNotifications;

  GlobalConfig({
    this.isCheckStart = false,
    this.isNoUpdateAvailableToast = false,
    this.isSourceUrl = false,
    this.isVerifiedSha256Android = false,
    this.isVerifiedSha256Windows = false,
    this.isRequestForNotifications = false,
  });
}

/// UI Configuration for Alert Dialog, Bottom Sheets, and Download Progress
class UIConfig {
  final String updateButtonText;
  final String skipButtonText;
  final String updateAvailableText;
  final String changelogText;
  final String titleDownloadBottomSheets;
  final String titleVerifiedSha256BottomSheets;
  final String toastNoUpdateFoundText;

  final TextStyle alertVersionNameStyle;
  final TextStyle alertChangeLogTextStyle;
  final TextStyle bottomSheetVersionNameTextStyle;
  final TextStyle bottomSheetChangeLogTextStyle;
  final TextStyle updateAvailableTextStyle;
  final TextStyle changelogTextStyle;

  final Icon customIconTitle;
  final DialogType dialogType;

  UIConfig({
    this.updateButtonText = 'Update',
    this.skipButtonText = 'Skip',
    this.updateAvailableText = 'Update Available',
    this.changelogText = 'Changelog',
    this.titleDownloadBottomSheets = 'Downloading...',
    this.titleVerifiedSha256BottomSheets = 'Verified sha256...',
    this.toastNoUpdateFoundText = 'No update found',

    this.alertVersionNameStyle =
    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    this.alertChangeLogTextStyle =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.bottomSheetVersionNameTextStyle =
    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    this.bottomSheetChangeLogTextStyle =
    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.updateAvailableTextStyle =
    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
    this.changelogTextStyle =
    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

    this.customIconTitle = const Icon(Icons.downloading_outlined),
    this.dialogType = DialogType.bottomSheet,

  });
}

/// Notification Configuration
class NotificationConfig {
  final String defaultIcon;
  final String downloadProgressNotificationTextTitle;
  final String downloadProgressNotificationTextBody;
  final String downloadFailedNotificationTitleText;
  final String downloadFailedNotificationBodyText;
  final String verifiedSha256NotificationTitleText;
  final String verifiedSha256NotificationBodyText;

  final bool showProgress;
  final bool channelShowBadge;

  NotificationConfig({
    this.defaultIcon = '@mipmap/ic_launcher',
    this.downloadProgressNotificationTextTitle = 'Download',
    this.downloadProgressNotificationTextBody = '',
    this.downloadFailedNotificationTitleText = 'Download failed',
    this.downloadFailedNotificationBodyText = 'An error occurred while downloading update. Check your internet connections and try again',
    this.verifiedSha256NotificationTitleText = 'Verified sha256',
    this.verifiedSha256NotificationBodyText = '',

    this.showProgress = true,
    this.channelShowBadge = true,
  });
}

/// Config for the plugin
class UpdateCenterConfig {
  final GlobalConfig globalConfig;
  final UIConfig uiConfig;
  final NotificationConfig notificationConfig;

  UpdateCenterConfig({
    required this.globalConfig,
    required this.uiConfig,
    required this.notificationConfig,
  });
}
