import 'package:flutter/material.dart';
import 'package:update_center/utils/constants.dart';
import '../config/config.dart';
import '../utils/download_utils.dart';

class MaterialBottomSheet extends StatelessWidget {
  final String versionName;
  final String changeLog;
  final bool allowSkip;
  final VoidCallback onUpdate; // Callback for the update action
  final UpdateCenterConfig config;
  final DownloadState downloadState;

  const MaterialBottomSheet(
      {super.key,
      required this.versionName,
      required this.changeLog,
      required this.config,
      required this.onUpdate,
      required this.downloadState,
      this.allowSkip = true});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 14),
              Center(
                child: Container(
                  width: 25,
                  height: 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 24.0,
            right: 24.0,
            bottom: 25.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(config.updateAvailableText,
                        style: config.updateAvailableTextStyle),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        config.iconBottomSheet,
                        const SizedBox(width: 8.0),
                        Text(
                          versionName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: downloadState.isDownloading,
                builder: (context, isDownloading, child) {
                  return FilledButton(
                    onPressed: isDownloading ? null : onUpdate,
                    child: Text(config.updateButtonText),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 12.0),
          child: Text(config.changelogText, style: config.changelogTextStyle),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(13.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Text(changeLog, style: config.bottomSheetChangeLogTextStyle),
            )
        ),
        sizeVer(20),
      ],
    ));
  }
}


