import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as h;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:update_center/provider/check_provider.dart';
import 'package:update_center/provider/notification_provider.dart';
import 'package:update_center/provider/permission_provider.dart';
import 'utils/download_utils.dart';
import 'config/config.dart';

export 'config/config.dart';
export 'utils/constants.dart';
export 'models/android.dart';
export 'models/ios.dart';
export 'models/windows.dart';
export 'provider/memory_provider.dart';
export 'provider/download_provider.dart';
export 'utils/download_utils.dart';
export 'package:open_filex/open_filex.dart';
export 'utils/onDownload.dart';

/// The main class responsible for checking and handling updates.
class UpdateCenter {
  /// Keeps track of the current download state.
  DownloadState downloadState = DownloadState();

  /// Constructor to initialize the UpdateCenter with necessary parameters.
  UpdateCenter({
    required this.context, // The context from which this instance is created.
    required this.urlJson, // The URL to fetch update JSON data.
    required this.config, // Configuration settings for UpdateCenter.
    this.allowSkip = true, // Flag to allow skipping the update.
  }) {
    WidgetsFlutterBinding.ensureInitialized();

    if (config.globalConfig.isRequestForNotifications) {
      PermissionProvider.requestForNotifications();
    }

    // If set in config, automatically check for updates after the first frame is rendered.
    if (config.globalConfig.isCheckStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        check();
      });
    }
    // Initialize notification provider with the configuration.
    var notificationProvider = NotificationProvider(config: config);
    notificationProvider.initialize();
  }

  final BuildContext context;
  final String urlJson;
  final bool allowSkip;
  final UpdateCenterConfig config;

  /// URL for downloading the update.
  final String _downloadUrl = '';

  /// Checks for updates based on the current platform and configuration.
  Future<bool> check() async {
    // Retrieve package information.
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    try {
      // Fetch update information from the specified URL.
      h.Response response = await h.get(Uri.parse(urlJson)).timeout(Duration(seconds: 30));

      // Handle cases where the response body is empty.
      if (response.body.isEmpty) {
        return false;
      }

      // Decode the JSON response.
      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      // Ensure the context is still valid.
      if (context.mounted) {
        // Check for updates based on the operating system.
        switch (Platform.operatingSystem) {
          case "android":
            return CheckProvider().checkAndroidUpdate(
              data["android"],
              packageInfo,
              allowSkip,
              context,
              downloadState,
              config,
              _downloadUrl,
            );

          case "ios":
            return CheckProvider().checkIOSUpdate(
              data["ios"],
              packageInfo,
              allowSkip,
              context,
              downloadState, // This value is not used in the iOS model
              config,
              _downloadUrl, // This value is not used in the iOS model
            );

          case "windows":
            return CheckProvider().checkWindowsUpdate(
              data["windows"],
              packageInfo,
              allowSkip,
              context,
              downloadState,
              config,
              _downloadUrl,
            );

          default:
            return false;
        }
      }
      return false;
    } catch (e) {
      // Handle any exceptions during the update check.
      log("Error in UpdateCenter.check: $e");
      return false;
    }
  }
}