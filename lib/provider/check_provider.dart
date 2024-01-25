import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/config.dart';
import '../utils/download_utils.dart';
import '../models/android.dart';
import '../models/ios.dart';
import '../models/windows.dart';
import 'dialog_provider.dart';
import 'memory_provider.dart';

/// The CheckProvider class is responsible for handling update checks for different platforms.
class CheckProvider {
  /// Checks for an available update for Android platform and shows update dialog if necessary.
  ///
  /// [androidData] - Data containing update details for Android.
  /// [packageInfo] - Current app package information.
  /// [withDialog] - Flag to show dialog if true.
  /// [allowSkip] - Flag to allow skipping the update.
  /// [context] - Current BuildContext.
  /// [downloadState] - State manager for download progress.
  /// [config] - Configuration settings for the update.
  /// [downloadUrl] - URL to download the update.
  Future<bool> checkAndroidUpdate(
    Map<String, dynamic> androidData,
    PackageInfo packageInfo,
    bool withDialog,
    bool allowSkip,
    BuildContext context,
    DownloadState downloadState,
    UpdateCenterConfig config,
    String downloadUrl,
  ) async {
    AndroidModel model = AndroidModel(
      androidData['downloadUrl'],
      androidData['versionName'],
      androidData['changeLog'],
      androidData['sourceUrl'],
      androidData['sha256checksum'],
      androidData['versionCode'],
      androidData['minSupport'],
    );

    int buildNumber = int.parse(packageInfo.buildNumber);

    if (model.minSupport > buildNumber) {
      allowSkip = false; // Update is mandatory
    }

    // Check if the current build number is less than the update version code
    if (buildNumber < model.versionCode) {
      if (withDialog) {
        DialogProvider().showUpdateDialog(
            model.versionName,
            model.changeLog,
            context,
            allowSkip,
            downloadState,
            model.downloadUrl,
            model.sourceUrl,
            config);
      }
      downloadUrl = model.downloadUrl; // Set the download URL

      return true; // Return true to indicate that an update is available
    }

    if (buildNumber >= model.versionCode) {
      if (config.isNoUpdateAvailableToast) {
        Fluttertoast.showToast(msg: "No updates found");
      }
      MemoryProvider.deleteFileDirectory();
      return false;
    }

    return false; // No update available
  }

  /// Checks for an available update for iOS platform and shows update dialog if necessary.
  ///
  /// [iosData] - Data containing update details for iOS.
  /// Similar parameters as checkAndroidUpdate.
  Future<bool> checkIOSUpdate(
    Map<String, dynamic> iosData,
    PackageInfo packageInfo,
    bool withDialog,
    bool allowSkip,
    BuildContext context,
    DownloadState downloadState,
    UpdateCenterConfig config,
    String downloadUrl,
  ) async {
    IOSModel model = IOSModel(
      iosData['versionName'],
      iosData['changeLog'],
      iosData['sourceUrl'],
      iosData['versionCode'],
      iosData['minSupport'],
    );

    int buildNumber = int.parse(packageInfo.buildNumber);

    if (model.minSupport > buildNumber) {
      allowSkip = false; // Update is mandatory
    }

    // Check if the current build number is less than the update version code
    if (buildNumber < model.versionCode) {
      if (withDialog) {
        DialogProvider().showUpdateDialog(
          model.versionName,
          model.changeLog,
          context,
          allowSkip,
          downloadState,
          downloadUrl,
          model.sourceUrl,
          config,
        );
      }
      return true; // Return true to indicate that an update is available
    }

    if (buildNumber >= model.versionCode) {
      if (config.isCheckStart == false) {
        Fluttertoast.showToast(msg: "No updates found");
      }
      return false;
    }
    return false; // No update available
  }

  /// Checks for an available update for Windows platform and shows update dialog if necessary.
  ///
  /// [windowsData] - Data containing update details for Windows.
  Future<bool> checkWindowsUpdate(
    Map<String, dynamic> windowsData,
    PackageInfo packageInfo,
    bool withDialog,
    bool allowSkip,
    BuildContext context,
    DownloadState downloadState,
    UpdateCenterConfig config,
    String downloadUrl,
  ) async {
    WindowsModel model = WindowsModel(
      windowsData['downloadUrl'],
      windowsData['versionName'],
      windowsData['changeLog'],
      windowsData['sourceUrl'],
      windowsData['sha256checksum'],
      windowsData['versionCode'],
      windowsData['minSupport'],
    );

    int buildNumber = int.parse(packageInfo.buildNumber);

    if (model.minSupport > buildNumber) {
      allowSkip = false; // Update is mandatory
    }

    // Check if the current build number is less than the update version code
    if (buildNumber < model.versionCode) {
      if (withDialog) {
        DialogProvider().showUpdateDialog(
            model.versionName,
            model.changeLog,
            context,
            allowSkip,
            downloadState,
            model.downloadUrl,
            model.sourceUrl,
            config);
      }
      downloadUrl = model.downloadUrl; // Set the download URL
      return true; // Return true to indicate that an update is available
    }

    if (buildNumber >= model.versionCode) {
      if (config.isCheckStart == false) {
        Fluttertoast.showToast(msg: "No updates found");
      }
      return false;
    }
    return false; // No update available
  }
}
