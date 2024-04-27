import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/config.dart';
import '../utils/download_utils.dart';
import '../models/android.dart';
import '../models/ios.dart';
import '../models/windows.dart';
import 'memory_provider.dart';

/// The CheckProvider class is responsible for handling update checks for different platforms.
class CheckProvider {
  /// Checks for an available update for Android platform and shows update dialog if necessary.
  Future<bool> checkAndroidUpdate(
    Map<String, dynamic> androidData,
    PackageInfo packageInfo,
    bool allowSkip,
    BuildContext context,
    DownloadState downloadState,
    UpdateCenterConfig config,
    String downloadUrl,
  ) async {
    AndroidModel model = AndroidModel(
      androidData['versionName'],
      androidData['downloadUrl'],
      androidData['changeLog'],
      androidData['sourceUrl'],
      androidData['versionCode'],
      androidData['minSupport'],
    );

    int buildNumber = int.parse(packageInfo.buildNumber);

    if (model.minSupport > buildNumber) {
      allowSkip = false; // Update is mandatory
    }

    // Check if the current build number is less than the update version code
    if (buildNumber < model.versionCode) {
      // Get the stored version info
      String? storedVersion = await MemoryProvider.getVersionInfoAndroid();

      // Compare with the new version
      if (storedVersion != null && storedVersion != model.versionName) {
        // Versions differ, delete the old file and stored version info
        MemoryProvider.deleteFileDirectory();
      }

      // Save the new version info
      await MemoryProvider.saveVersionInfoAndroid(model.versionName);

      if (context.mounted && config.globalConfig.androidDialogBuilder != null) {
        await config.globalConfig.androidDialogBuilder!(
          context,
          model, // Assume this is your AndroidModel instance with update info
          config,
          downloadState, // Your DownloadState instance
          allowSkip,
        );
      }

      downloadUrl = model.downloadUrl; // Set the download URL

      return true; // Return true to indicate that an update is available
    }

    // Returns your custom widget "No updates found"
    if (buildNumber >= model.versionCode) {
      if (config.globalConfig.isNoUpdateAvailableToast && config.globalConfig.androidNoUpdateAvailableBuilder != null) {
        config.globalConfig.androidNoUpdateAvailableBuilder?.call(context);
      }

      MemoryProvider.deleteFileDirectory(); // Deletes the old file if there is no update
      return false;
    }

    return false; // No update available
  }

  /// Checks for an available update for iOS platform and shows update dialog if necessary.
  Future<bool> checkIOSUpdate(
    Map<String, dynamic> iosData,
    PackageInfo packageInfo,
    bool allowSkip,
    BuildContext context,
    DownloadState downloadState,
    UpdateCenterConfig config,
    String downloadUrl, // This value is not used in the iOS model
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
      if (context.mounted && config.globalConfig.iosDialogBuilder != null) {
        await config.globalConfig.iosDialogBuilder!(
            context,
            model, // Assume this is your AndroidModel instance with update info
            config,
            downloadState, // Your DownloadState instance
            allowSkip);
      }

      return true; // Return true to indicate that an update is available
    }

    if (buildNumber >= model.versionCode) {
      if (config.globalConfig.isNoUpdateAvailableToast && config.globalConfig.iosNoUpdateAvailableBuilder != null) {
        config.globalConfig.iosNoUpdateAvailableBuilder?.call(context);
      }
      return false;
    }
    return false; // No update available
  }

  /// Checks for an available update for Windows platform and shows update dialog if necessary.
  Future<bool> checkWindowsUpdate(
    Map<String, dynamic> windowsData,
    PackageInfo packageInfo,
    bool allowSkip,
    BuildContext context,
    DownloadState downloadState,
    UpdateCenterConfig config,
    String downloadUrl,
  ) async {
    WindowsModel model = WindowsModel(
      windowsData['versionName'],
      windowsData['downloadUrl'],
      windowsData['changeLog'],
      windowsData['sourceUrl'],
      windowsData['versionCode'],
      windowsData['minSupport'],
    );

    int buildNumber = int.parse(packageInfo.buildNumber);

    if (model.minSupport > buildNumber) {
      allowSkip = false; // Update is mandatory
    }

    // Check if the current build number is less than the update version code
    if (buildNumber < model.versionCode) {
      // Get the stored version info
      String? storedVersion = await MemoryProvider.getVersionInfoWindows();

      // Compare with the new version
      if (storedVersion != null && storedVersion != model.versionName) {
        // Versions differ, delete the old file and stored version info
        MemoryProvider.deleteFileDirectoryWindows();
      }

      // Save the new version info
      await MemoryProvider.saveVersionInfoWindows(model.versionName);

      if (context.mounted && config.globalConfig.windowsDialogBuilder != null) {
        await config.globalConfig.windowsDialogBuilder!(
            context,
            model, // Assume this is your AndroidModel instance with update info
            config,
            downloadState, // Your DownloadState instance
            allowSkip);
      }

      downloadUrl = model.downloadUrl; // Set the download URL
      return true; // Return true to indicate that an update is available
    }

    if (buildNumber >= model.versionCode) {
      if (config.globalConfig.isNoUpdateAvailableToast) {
        if (config.globalConfig.isNoUpdateAvailableToast && config.globalConfig.windowsNoUpdateAvailableBuilder != null) {
          config.globalConfig.windowsNoUpdateAvailableBuilder?.call(context);
        }
      }
      MemoryProvider.deleteFileDirectoryWindows();
      return false;
    }
    return false; // No update available
  }
}
