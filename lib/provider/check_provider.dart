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

class CheckProvider {

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
            config
        );
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