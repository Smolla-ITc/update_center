library update_center;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as h;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';
import 'package:update_center/provider/check_provider.dart';
import 'package:update_center/provider/notification_provider.dart';
import 'utils/download_utils.dart';
import 'config/config.dart';
export 'config/config.dart';
export 'utils/constants.dart';

class UpdateCenter {
  DownloadState downloadState = DownloadState();

  UpdateCenter({
    required this.context,
    required this.urlJson,
    required this.changeLog,
    required this.versionName,
    required this.config,
    this.allowSkip = true,
    this.delay,
  }) {
    if (config.isCheckStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        check(); // Call check method after the frame is rendered
      });
    }
    var notificationProvider = NotificationProvider(config: config);
    WidgetsFlutterBinding.ensureInitialized();
    notificationProvider.initialize();
  }

  final BuildContext context;

  final String urlJson;

  String changeLog;

  String versionName;

  bool allowSkip;

  final Duration? delay;

  final UpdateCenterConfig config;

  @visibleForTesting
  static Platform platform = const LocalPlatform();

  String downloadUrl = '';

  Future<bool> check({withDialog = true}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    try {
      h.Response response = await h.get(Uri.parse(urlJson));

      if (response.body.isEmpty) {
        return false; // Handle empty response body
      }

      Map<String, dynamic> data = jsonDecode(response.body.toString());

      if (context.mounted) {
        switch (platform.operatingSystem) {
          case "android":
            return CheckProvider().checkAndroidUpdate(
              data["android"],
              packageInfo,
              withDialog,
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
              withDialog,
              allowSkip,
              context,
              downloadState,
              config,
              downloadUrl,
            );

          case "windows":
            return CheckProvider().checkWindowsUpdate(
              data["windows"],
              packageInfo,
              withDialog,
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
      print("Error in UpdateCenter.check: $e");
      return false; // Handle parsing errors or other exceptions
    }
  }
}