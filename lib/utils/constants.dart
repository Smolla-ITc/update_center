import 'package:flutter/material.dart';
import 'package:update_center/config/config.dart';
import '../models/android.dart';
import '../models/windows.dart';
import 'download_utils.dart';

/// Used to determine the vertical offset
Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

// Used to determine the horizontal offset
Widget sizeHor(double width) {
  return SizedBox(width: width);
}


typedef AndroidDialogBuilder = Future<void> Function(
    BuildContext context,
    AndroidModel model,
    UpdateCenterConfig updateCenterConfig,
    DownloadState downloadState,
    bool allowSkip);

typedef WindowsDialogBuilder = Future<void> Function(
    BuildContext context,
    WindowsModel model,
    UpdateCenterConfig updateCenterConfig,
    DownloadState downloadState,
    bool allowSkip);

typedef NoUpdateAvailableBuilder = void Function(BuildContext context);
