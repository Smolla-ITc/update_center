import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A utility class for handling file storage operations in the application.
class MemoryProvider {
  static const String versionInfoKey = 'version_info';

  /// Retrieves a local file reference for Android, based on a given URL.
  /// The file is expected to be in the application's document directory.
  static Future<File> getLocalFileAndroid(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filename = url.split('/').last;
    return File('${directory.path}/UpdateCenter/$filename');
  }

  /// Deletes all files within the UpdateCenter directory for Android.
  /// This method is useful for cleaning up downloaded files.
  static void deleteFileDirectory() async {
    Directory updateDirectory = await directoryAndroid();

    if (await updateDirectory.exists()) {
      // List all files in the directory
      List<FileSystemEntity> files = updateDirectory.listSync();

      // Delete each file in the directory
      for (var file in files) {
        if (file is File) {
          await file.delete();
          log('Deleted file successfully: ${file.path}');
        }
      }
    }
  }

  static void deleteFileDirectoryWindows() async {
    Directory updateDirectory = await directoryWindows();

    if (await updateDirectory.exists()) {
      // List all files in the directory
      List<FileSystemEntity> files = updateDirectory.listSync();

      // Delete each file in the directory
      for (var file in files) {
        if (file is File) {
          await file.delete();
          log('Deleted file successfully: ${file.path}');
        }
      }
    }
  }

  /// Provides the UpdateCenter directory in the application's documents directory for Android.
  /// Creates the directory if it doesn't exist.
  static Future<Directory> directoryAndroid() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory updateDirectory = Directory('${tempDir.path}/UpdateCenter/');

    if (!await updateDirectory.exists()) {
      await updateDirectory.create(recursive: true);
    }
    return updateDirectory;
  }

  /// Retrieves a local file reference for Windows, based on a given URL.
  /// The file is expected to be in the system's downloads directory.
  static Future<File> getLocalFileWindows(String url) async {
    final directory = await getDownloadsDirectory();
    final filename = url.split('/').last;
    return File('${directory?.path}/Update Center/$filename');
  }

  /// Provides the UpdateCenter directory in the system's downloads directory for Windows.
  /// Creates the directory if it doesn't exist.
  static Future<Directory> directoryWindows() async {
    Directory? tempDir = await getDownloadsDirectory();
    Directory updateDirectory = Directory('${tempDir?.path}/Update Center/');

    if (!await updateDirectory.exists()) {
      await updateDirectory.create(recursive: true);
    }
    return updateDirectory;
  }

  // Saves the version information of the downloaded file
  static Future<void> saveVersionInfoAndroid(String versionName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(versionInfoKey, versionName);
  }

  // Retrieves the version information of the downloaded file
  static Future<String?> getVersionInfoAndroid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(versionInfoKey);
  }

  // Saves the version information of the downloaded file
  static Future<void> saveVersionInfoWindows(String versionName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(versionInfoKey, versionName);
  }

  // Retrieves the version information of the downloaded file
  static Future<String?> getVersionInfoWindows() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(versionInfoKey);
  }
}
