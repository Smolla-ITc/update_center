import 'package:flutter/material.dart';
import 'package:update_center/utils/download_utils.dart';
import 'package:update_center/update_center.dart';

/// Bottom sheet material is used to display update download progress
class DownloadProgressBottomSheet extends StatelessWidget {
  final DownloadState downloadState;

  final UpdateCenterConfig config;

  final bool allowSkip;

  const DownloadProgressBottomSheet({
    super.key,
    required this.downloadState,
    required this.config,
    required this.allowSkip,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: downloadState.isDownloading,
      builder: (context, isDownloading, child) {
        if (!isDownloading) {
          // Close the bottom sheet when download is complete
          Future.microtask(() => Navigator.of(context).pop());
        }
        return child!;
      },
      child: _buildDownloadProgressUI(context),
    );
  }

  Widget _buildDownloadProgressUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                sizeVer(10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: ValueListenableBuilder<bool>(
                  valueListenable: downloadState.isVerifiedSha256,
                  builder: (_, isVerifiedSha256, __) {
                    String text = isVerifiedSha256
                        ? config.uiConfig.titleVerifiedSha256BottomSheets
                        : config.uiConfig.titleDownloadBottomSheets;

                    return Text(
                      text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              if (allowSkip)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: downloadState.isVerifiedSha256.value
                          ? null
                          : () async {
                              Navigator.pop(context);
                            }),
                ),
            ],
          ),
          sizeVer(10),
          Align(
            alignment: Alignment.topLeft,
            child: ValueListenableBuilder<String>(
              valueListenable: downloadState.progressText,
              builder: (_, progressText, __) {
                return Row(
                  children: [
                    config.uiConfig.customIconTitle,
                    sizeHor(5),
                    Text(
                      progressText,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          sizeVer(10),
          ValueListenableBuilder<double>(
            valueListenable: downloadState.progress,
            builder: (context, progress, _) {
              return Row(
                children: [
                  const SizedBox(width: 33),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: downloadState.isVerifiedSha256.value ||
                              progress == 0.0
                          ? null
                          : progress,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
          sizeVer(20)
        ],
      ),
    );
  }
}
