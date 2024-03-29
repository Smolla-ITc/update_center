import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dialog/cupertino_alert_dialog.dart';
import 'download_provider.dart';
import '../utils/download_utils.dart';
import '../config/config.dart';
import '../utils/constants.dart';
import '../dialog/material_alert_dialog.dart';
import '../dialog/material_bottom_sheet.dart';
import '../dialog/download_bottom_sheets.dart';
import 'memory_provider.dart';

/// DialogProvider class to handle showing different types of update dialogs based on platform and configuration.
class DialogProvider {
  /// Shows the appropriate update dialog based on platform and dialog type configuration.
  void showUpdateDialog(
      String versionName,
      String changeLog,
      BuildContext context,
      bool allowSkip,
      DownloadState downloadState,
      String downloadUrl,
      String sha256checksum,
      String sourceUrl,
      UpdateCenterConfig config) {
    // For alertDialog type, shows platform-specific dialogs.
    if (config.uiConfig.dialogType == DialogType.alertDialog) {
      // Shows a Cupertino style dialog for iOS, Material style for Android and Windows.
      if (Platform.isIOS) {
        _showCupertinoAlertDialog(
            versionName, changeLog, context, allowSkip, sourceUrl, config);
      } else if (Platform.isAndroid || Platform.isWindows) {
        _showMaterialAlertDialog(versionName, changeLog, sourceUrl, context,
            allowSkip, downloadState, downloadUrl, sha256checksum, config);
      }
    } else {
      // Shows a bottom sheet dialog for other platforms or configuration.
      _showMaterialBottomSheet(versionName, changeLog, sourceUrl, context,
          allowSkip, downloadState, downloadUrl, sha256checksum, config);
    }
  }

  /// Private method to show a Material style alert dialog.
  void _showMaterialAlertDialog(
      String versionName,
      String changeLog,
      String sourceUrl,
      BuildContext context,
      bool allowSkip,
      DownloadState downloadState,
      String downloadUrl,
      String sha256checksum,
      UpdateCenterConfig config) {
    showDialog(
      context: context,
      barrierDismissible: allowSkip,
      builder: (BuildContext context) {
        return MaterialAlertDialog(
          versionName: versionName,
          changeLog: changeLog,
          allowSkip: allowSkip,
          config: config,
          onUpdate: () async {
            if (allowSkip) {
              Navigator.of(context).pop();
            }

            if (config.globalConfig.isOpenFile) {
              File localFile;
              if (Platform.isWindows) {
                localFile =
                    await MemoryProvider.getLocalFileWindows(downloadUrl);
              } else if (Platform.isAndroid) {
                localFile =
                    await MemoryProvider.getLocalFileAndroid(downloadUrl);
              } else {
                // Handle other platforms if necessary
                return;
              }

              if (await localFile.exists()) {
                log(localFile.path);

                // Optionally, open the file directly
                await OpenFilex.open(localFile.path);
                return;
              }
            }

            if (context.mounted) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) => PopScope(
                        canPop: false,
                        child: DownloadProgressBottomSheet(
                          downloadState: downloadState,
                          config: config,
                          allowSkip: allowSkip,
                        ),
                      ));
            }

            /// Checks the isSourceUrl value from the file in main.dart
            /// if the value is true, it uses [_launchURL], otherwise, the download is in progress.
            if (config.globalConfig.isSourceUrl) {
              _launchURL(sourceUrl);
            } else {
              if (Platform.isWindows) {
                DownloadProvider.downloadUpdateWindows(downloadUrl, versionName,
                    (progress) {}, config, downloadState, sha256checksum);
              } else if (Platform.isAndroid) {
                DownloadProvider.downloadUpdateAndroid(downloadUrl, versionName,
                    (progress) {}, config, downloadState, sha256checksum);
              }
            }
          },
          onSkip: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// Private method to show a Cupertino style alert dialog.
  void _showCupertinoAlertDialog(
      String versionName,
      String changeLog,
      BuildContext context,
      bool allowSkip,
      String sourceUrl,
      UpdateCenterConfig config) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: allowSkip,
      builder: (BuildContext context) {
        return CupertinoDialog(
          versionName: versionName,
          changeLog: changeLog,
          allowSkip: allowSkip,
          config: config,
          onUpdate: () {
            _launchURL(sourceUrl);
          },
          onSkip: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// Helper method to launch a URL using the url_launcher package.
  _launchURL(String sourceUrl) async {
    final Uri url = Uri.parse(sourceUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $sourceUrl');
    }
  }

  /// Private method to show a Material style bottom sheet.
  void _showMaterialBottomSheet(
      String versionName,
      String changeLog,
      String sourceUrl,
      BuildContext context,
      bool allowSkip,
      DownloadState downloadState,
      String downloadUrl,
      String sha256checksum,
      UpdateCenterConfig config) {
    showModalBottomSheet(
      isDismissible: allowSkip,
      isScrollControlled: true,
      enableDrag: allowSkip,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: allowSkip,
          child: MaterialBottomSheet(
            versionName: versionName,
            downloadState: downloadState,
            changeLog: changeLog,
            config: config,
            onUpdate: () async {
              if (allowSkip) {
                Navigator.of(context).pop();
              }

              if (config.globalConfig.isOpenFile) {
                File localFile;
                if (Platform.isWindows) {
                  localFile =
                      await MemoryProvider.getLocalFileWindows(downloadUrl);
                } else if (Platform.isAndroid) {
                  localFile =
                      await MemoryProvider.getLocalFileAndroid(downloadUrl);
                } else {
                  // Handle other platforms if necessary
                  return;
                }

                if (await localFile.exists()) {
                  log(localFile.path);

                  // Optionally, open the file directly
                  await OpenFilex.open(localFile.path);
                  return;
                }
              }

              if (context.mounted) {
                showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: false,
                    enableDrag: false,
                    context: context,
                    builder: (context) => PopScope(
                          canPop: false,
                          child: DownloadProgressBottomSheet(
                            downloadState: downloadState,
                            config: config,
                            allowSkip: allowSkip,
                          ),
                        ));
              }

              /// Checks the isSourceUrl value from the file in main.dart
              /// if the value is true, it uses [_launchURL], otherwise, the download is in progress.
              if (config.globalConfig.isSourceUrl) {
                _launchURL(sourceUrl);
              } else {
                if (Platform.isWindows) {
                  DownloadProvider.downloadUpdateWindows(
                      downloadUrl,
                      versionName,
                      (progress) {},
                      config,
                      downloadState,
                      sha256checksum);
                } else if (Platform.isAndroid) {
                  DownloadProvider.downloadUpdateAndroid(
                      downloadUrl,
                      versionName,
                      (progress) {},
                      config,
                      downloadState,
                      sha256checksum);
                }
              }
            },
          ),
        );
      },
    );
  }
}
