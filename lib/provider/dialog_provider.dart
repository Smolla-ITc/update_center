import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dialog/cupertino_alert_dialog.dart';
import 'download_provider.dart';
import '../utils/download_utils.dart';
import '../config/config.dart';
import '../utils/constants.dart';
import '../dialog/material_alert_dialog.dart';
import '../dialog/material_bottom_sheet.dart';
import '../dialog/download_bottom_sheets.dart';

class DialogProvider {

  void showUpdateDialog(
      String versionName,
      String changeLog,
      BuildContext context, bool allowSkip,
      DownloadState downloadState,
      String downloadUrl,
      String sourceUrl,
      UpdateCenterConfig config
      ) {
    if (config.dialogType == DialogType.alertDialog) {

      if(Platform.isIOS){
        _showCupertinoAlertDialog(versionName, changeLog, context, allowSkip, sourceUrl, config);
      }

      if(Platform.isAndroid) {
        _showMaterialAlertDialog(versionName, changeLog, context, allowSkip, downloadState, downloadUrl, config);
      }

    } else {
      _showMaterialBottomSheet(versionName, changeLog, context, allowSkip, downloadState, downloadUrl, config);
    }
  }

  void _showMaterialAlertDialog(
      String versionName,
      String changeLog,
      BuildContext context,
      bool allowSkip,
      DownloadState downloadState,
      String downloadUrl,
      UpdateCenterConfig config

      ) {
    showDialog(
      context: context,
      barrierDismissible: allowSkip,
      builder: (BuildContext context) {
        return MaterialAlertDialog(
          versionName: versionName,
          changeLog: changeLog,
          allowSkip: allowSkip,
          config: config,
          onUpdate: () {
            if (Platform.isWindows) {
              DownloadProvider.downloadUpdateWindows(
                  downloadUrl, versionName, (progress) {}, config,
                  downloadState);
            }
            if (Platform.isAndroid) {
              DownloadProvider.downloadUpdateAndroid(
                  downloadUrl, versionName, (progress) {}, config,
                  downloadState);
            }
          },
          onSkip: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showCupertinoAlertDialog(
      String versionName,
      String changeLog,
      BuildContext context,
      bool allowSkip,
      String sourceUrl,
      UpdateCenterConfig config
      ) {
    showCupertinoModalPopup(

      context: context,
      barrierDismissible: allowSkip,
      builder: (BuildContext context) {
        return
          CupertinoDialog(
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


  _launchURL(String sourceUrl) async {
    final Uri url = Uri.parse(sourceUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $sourceUrl');
    }
  }

  void _showMaterialBottomSheet(
      String versionName,
      String changeLog,
      BuildContext context,
      bool allowSkip,
      DownloadState downloadState,
      String downloadUrl,
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
            onUpdate: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) =>
                      PopScope(
                        canPop: false,
                        child: DownloadProgressBottomSheets(
                          downloadState: downloadState,
                          config: config,
                          allowSkip: allowSkip,
                        ),
                      )
              );
              if (Platform.isWindows) {
                DownloadProvider.downloadUpdateWindows(
                    downloadUrl, versionName, (progress) {}, config,
                    downloadState);
              }
              if (Platform.isAndroid) {
                DownloadProvider.downloadUpdateAndroid(
                    downloadUrl, versionName, (progress) {}, config,
                    downloadState);
              }
            },
          ),
        );
      },
    );
  }
}