import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Config for the plugin
class UpdateCenterConfig {
  // Global Configuration
  final bool isCheckStart;
  final bool isNoUpdateAvailableToast;
  final bool isSourceUrl;

  // UI Configuration for Alert Dialog, Bottom Sheets, and Download Progress
  final TextStyle alertVersionNameStyle;
  final TextStyle alertChangeLogTextStyle;
  final TextStyle bottomSheetVersionNameTextStyle;
  final TextStyle bottomSheetChangeLogTextStyle;
  final TextStyle updateAvailableTextStyle;
  final TextStyle changelogTextStyle;
  final String updateButtonText;
  final String skipButtonText;
  final String updateAvailableText;
  final String changelogText;
  final String titleDownloadBottomSheets;
  final Icon customIconTitle;
  final DialogType dialogType;

  // Notification Configuration
  final String defaultIcon;
  final String downloadProgressNotificationTextTitle;
  final String downloadProgressNotificationTextBody;
  final String downloadFailedNotificationTitleText;
  final String downloadFailedNotificationBodyText;
  final bool showProgress;
  final bool channelShowBadge;

  UpdateCenterConfig({
    // Global Config
    this.isCheckStart = false,
    this.isNoUpdateAvailableToast = false,
    this.isSourceUrl = false,

    // UI Config
    this.alertVersionNameStyle =
        const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    this.alertChangeLogTextStyle =
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.bottomSheetVersionNameTextStyle =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    this.bottomSheetChangeLogTextStyle =
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.updateAvailableTextStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    this.changelogTextStyle =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    this.updateButtonText = 'Update',
    this.skipButtonText = 'Skip',
    this.updateAvailableText = 'Update Available',
    this.changelogText = 'Changelog',
    this.titleDownloadBottomSheets = 'Downloading...',
    this.customIconTitle = const Icon(Icons.downloading_outlined),
    this.dialogType = DialogType.bottomSheet,

    // Notification Config
    this.defaultIcon = '@mipmap/ic_launcher',
    this.downloadProgressNotificationTextTitle = 'Download',
    this.downloadProgressNotificationTextBody = 'Downloading file...',
    this.showProgress = true,
    this.channelShowBadge = false,
    this.downloadFailedNotificationTitleText = 'Download failed',
    this.downloadFailedNotificationBodyText =
        'An error occurred while downloading update. Check your internet connections and try again',
  });
}
