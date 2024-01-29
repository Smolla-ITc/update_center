library update_center;

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as h;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';
import 'package:update_center/provider/check_provider.dart';
import 'package:update_center/provider/notification_provider.dart';
import 'package:update_center/provider/permission_provider.dart';
import 'utils/download_utils.dart';
import 'config/config.dart';
export 'config/config.dart';
export 'utils/constants.dart';

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

  bool allowSkip;
  final UpdateCenterConfig config;

  /// For testing purposes, allows mocking of the platform.
  @visibleForTesting
  static Platform platform = const LocalPlatform();

  /// URL for downloading the update.
  String downloadUrl = '';

  /// Plug for iOS model
  String sha256checksum = '';

  /// Checks for updates based on the current platform and configuration.
  Future<bool> check() async {
    // Retrieve package information.
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    try {
      // Fetch update information from the specified URL.
      h.Response response = await h.get(Uri.parse(urlJson));

      // Handle cases where the response body is empty.
      if (response.body.isEmpty) {
        return false;
      }

      // Decode the JSON response.
      Map<String, dynamic> data = jsonDecode(response.body.toString());

      // Ensure the context is still valid.
      if (context.mounted) {
        // Check for updates based on the operating system.
        switch (platform.operatingSystem) {
          case "android":
            return CheckProvider().checkAndroidUpdate(
              data["android"],
              packageInfo,
              allowSkip,
              context,
              downloadState,
              config,
              downloadUrl,
            );

          case "ios":
            return CheckProvider().checkIOSUpdate(
              data["ios"],
              packageInfo,
              allowSkip,
              context,
              downloadState, // This value is not used in the iOS model
              config,
              downloadUrl, // This value is not used in the iOS model
              sha256checksum, // This value is not used in the iOS model
            );

          case "windows":
            return CheckProvider().checkWindowsUpdate(
              data["windows"],
              packageInfo,
              allowSkip,
              context,
              downloadState,
              config,
              downloadUrl,
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
