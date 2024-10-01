import 'dart:developer';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as h;
import 'package:update_center/provider/memory_provider.dart';
import 'package:update_center/provider/notification_provider.dart';
import 'package:update_center/config/config.dart';
import '../utils/download_utils.dart';

/// Provides functionality to handle the download process for updates.
class DownloadProvider {
  /// Downloads an update for Android platform.
  ///
  /// [url] - URL of the file to be downloaded.
  /// [versionName] - Name of the version to be downloaded.
  /// [onProgress] - Callback function to handle progress updates.
  /// [config] - Configuration settings for the update process.
  /// [downloadState] - State of the download process.
  static Future<void> downloadUpdateAndroid(
    String url,
    String versionName,
    Function(double) onProgress,
    UpdateCenterConfig config,
    DownloadState downloadState,
  ) async {
    downloadState.isDownloading.value = true;

    var notificationProvider = NotificationProvider(config: config);

    var response = await h.Client().send(h.Request('GET', Uri.parse(url)));

    Directory tempDirectory = await MemoryProvider.directoryAndroid();

    String fileName = '${tempDirectory.path}/${url.split('/').last}';

    final contentLength = response.contentLength ?? 0;

    int bytesDownloaded = 0;

    double lastNotifiedProgress = 0.0;

    final file = await MemoryProvider.getLocalFileAndroid(url);

    var fileStream = file.openWrite();

    response.stream.listen(
      (List<int> newBytes) {
        notificationProvider.cancelNotification(3000);

        bytesDownloaded += newBytes.length;

        fileStream.add(newBytes);

        // Calculate progress
        double currentProgress = bytesDownloaded / contentLength;
        onProgress(currentProgress);

        // Inside your download logic
        downloadState.progress.value =
            currentProgress; // currentProgress is a value between 0.0 and 1.0
        downloadState.progressText.value =
            "${formatBytes(bytesDownloaded, 2)}/${formatBytes(contentLength, 2)}";

        // Throttle the notification update
        if (currentProgress - lastNotifiedProgress >= 0.02 || currentProgress == 1.0) {
          notificationProvider.showDownloadProgress(maxProgress: contentLength, progress: bytesDownloaded, versionName: versionName);
          lastNotifiedProgress = currentProgress;
        }
      },
      onDone: () async {
        await fileStream.flush();
        await fileStream.close();
        notificationProvider.cancelNotification(1000);

        await OpenFilex.open(fileName);

        downloadState.isDownloading.value = false;
      },
      onError: (e) async {
        await fileStream.close();

        downloadState.isDownloading.value = false;

        notificationProvider.cancelNotification(1000);

        // Show notification about download failure
        notificationProvider.showGenericNotification(
            id: 3000,
            title: config.notificationConfig.downloadFailedNotificationTitleText,
            body: config.notificationConfig.downloadFailedNotificationBodyText);

        log(e);
      },
      cancelOnError: true,
    );
  }

  /// Same as Android only for Windows
  static Future<void> downloadUpdateWindows(
    String url,
    String versionName,
    Function(double) onProgress,
    UpdateCenterConfig config,
    DownloadState downloadState,
  ) async {
    downloadState.isDownloading.value = true;

    var response = await h.Client().send(h.Request('GET', Uri.parse(url)));

    Directory tempDirectory = await MemoryProvider.directoryWindows();

    String fileName = '${tempDirectory.path}/${url.split('/').last}';

    final contentLength = response.contentLength ?? 0;

    int bytesDownloaded = 0;

    double lastNotifiedProgress = 0.0;

    final file = await MemoryProvider.getLocalFileWindows(url);

    var fileStream = file.openWrite();

    response.stream.listen(
      (List<int> newBytes) {
        bytesDownloaded += newBytes.length;
        fileStream.add(newBytes);

        // Calculate progress
        double currentProgress = bytesDownloaded / contentLength;
        onProgress(currentProgress);

        // Inside your download logic
        downloadState.progress.value = currentProgress; // currentProgress is a value between 0.0 and 1.0
        downloadState.progressText.value = "${formatBytes(bytesDownloaded, 2)}/${formatBytes(contentLength, 2)}";

        // Throttle the notification update
        if (currentProgress - lastNotifiedProgress >= 0.02 || currentProgress == 1.0) {
          lastNotifiedProgress = currentProgress;
        }
      },

      onDone: () async {
        await fileStream.flush();
        await fileStream.close();

        await OpenFilex.open(fileName);

        downloadState.isDownloading.value = false;
      },
      onError: (e) async {
        await fileStream.close();
        downloadState.isDownloading.value = false;
        log(e);
      },
      cancelOnError: true,
    );
  }
}