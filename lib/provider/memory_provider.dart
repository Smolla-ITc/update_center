import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MemoryProvider {
  static Future<File> getLocalFileAndroid(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filename = url.split('/').last;
    return File('${directory.path}/UpdateCenter/$filename');
  }
  static void deleteFileDirectory() async {
      Directory updateDirectory = await directoryAndroid();

    if (await updateDirectory.exists()) {
      // List all files in the directory
      List<FileSystemEntity> files = updateDirectory.listSync();

      // Delete each file in the directory
      for (var file in files) {
        if (file is File) {
          await file.delete();
          print('Deleted file successfully: ${file.path}');
        }
      }
    }
  }

  static Future<Directory> directoryAndroid() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory updateDirectory = Directory('${tempDir.path}/UpdateCenter/');

    if (!await updateDirectory.exists()) {
      await updateDirectory.create(recursive: true); // Create the directory if it doesn't exist
    }
    return updateDirectory;
  }

  static Future<File> getLocalFileWindows(String url) async {
    final directory = await getDownloadsDirectory();
    final filename = url.split('/').last;
    return File('${directory?.path}/UpdateCenter/$filename');
  }

  static Future<Directory> directoryWindows() async {
    Directory? tempDir = await getDownloadsDirectory();
    Directory updateDirectory = Directory('${tempDir?.path}/UpdateCenter/');

    if (!await updateDirectory.exists()) {
      await updateDirectory.create(recursive: true); // Create the directory if it doesn't exist
    }
    return updateDirectory;
  }
}
