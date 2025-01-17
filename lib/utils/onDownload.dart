import 'dart:developer';
import 'dart:io';
import '../update_center.dart';

/// Class to call downloading the update file and opening it

class OnDownload {
  static Future<void> initiateUpdate({
    required String url,
    required String versionName,
    required UpdateCenterConfig config,
    required DownloadState downloadState,
    required Future<void> Function(String url) launchUrl,
    String? sourceUrl,
  }) async {
    if (config.globalConfig.openingFile) {
      File localFile;
      if (Platform.isWindows) {
        localFile = await MemoryProvider.getLocalFileWindows(url);
      } else if (Platform.isAndroid) {
        localFile = await MemoryProvider.getLocalFileAndroid(url);
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

    // Next, check if the source URL should be launched instead of downloading
    if (config.globalConfig.sourceUrl && sourceUrl != null) {
      await launchUrl(sourceUrl);
      return;
    }

    // Based on the platform, initiate the appropriate download method
    if (Platform.isWindows) {
      await DownloadProvider.downloadUpdateWindows(
        url,
        versionName,
        (progress) {},
        config,
        downloadState,
      );
    } else if (Platform.isAndroid) {
      await DownloadProvider.downloadUpdateAndroid(
        url,
        versionName,
        (progress) {},
        config,
        downloadState,
      );
    }
  }
}
