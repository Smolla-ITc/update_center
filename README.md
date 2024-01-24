[![Pub Version](https://img.shields.io/pub/v/update_center?color=orange)](https://pub.dev/packages/update_center)

# ![UpdateCenter Icon](./assets/ic_uc.png) Update Center

## Flutter plugin that allows you to implement multi-check for updates for different platforms Android, IOS, Windows.

# IMPORTANT INFORMATION! ⚠

## This plugin is under active development and many features have not yet been implemented. The plugin now works well with Android and Windows, you can now use the plugin for these platforms. IOS is partially implemented, but it can also work, but improvements are needed. Loading progress for MaterioaAlertDialog has not been implemented yet. Also for Windows in the future the window design will be changed to fluent_ui but material support will remain. I couldn’t check the functionality of the IOS plugin because I don’t have access to an iPhone or Mac Book, but in theory it should work just you can check the functionality of IOS in your project and if you find bugs, write to this mail support@sunsetgram.com or add a comment to issues in the github project https://github.com/Smolla-ITc/update_center/issues.

# What has been implemented so far.

- Automatic update check depending on the platform the plugin runs on.
- Show notifications about download progress and download errors (The plugin does not yet know how to issue a notification request this will be added in subsequent updates).
- The plugin may prohibit skipping an update if the code in json is higher than the local versionCode, preventing the dialog or bottom sheet from being closed.
- The plugin may partially work with downloaded files. They will be deleted after the update is complete. This works on both Android and Windows. Download files are stored in Windows directories – download folder “/UpdateCenter/”
  Android - internal memory. Improvements are also needed.
- Once the download is complete, the files themselves open in supported formats. In Windows zip and exe and also any file. And Android is similar.
- And there is also flexible customization of the plugin, see example below. These are not all the settings many more settings will be added in the future.

# Getting started

The plugin works with a Json file so make sure you have somewhere to place this file.

### Add package to your pubspec.yaml

```yaml
dependencies:
  update_center: ^1.0.0-alpha.2+1
```

## Json file structure

```json
{
  "android": {
    "versionCode": 2,
    "versionName": "1.1.0",
    "downloadUrl": "https://example.com/UpdateCenetr/app.apk",
    "changeLog": "- bug fixed; \n- new ui;",
    "sourceUrl": "https://example.com/",
    "sha256checksum": "",
    "minSupport": 1
  },

  "ios": {
    "versionCode": 2,
    "versionName": "1.1.0",
    "changeLog": "- Bug fixes and performance improvements. \n- new ui",
    "sourceUrl": "https://example.com/",
    "minSupport": 1
  },

  "windows": {
    "versionCode": 34,
    "versionName": "5.0.0",
    "downloadUrl": "https://example.com/UdateCenter/app-windows.exe",
    "changeLog": "- Bug fixes and performance improvements. \n- New Icon;",
    "sourceUrl": "https://example.com/",
    "sha256checksum": "",
    "minSupport": 14
  }
}
```
## Description of the json structure

```txt
{
    "android": {
        "versionCode": 2, // Integer representing the new version code for Android
        "versionName": "1.1.0", // String representing the new version name for Android
        "downloadUrl": "https://example.com/UpdateCenetr/app.apk", // URL to download the new Android APK
        "changeLog": "- bug fixed; \n- new ui;", // Change log detailing what's new or fixed in this version
        "sourceUrl": "https://example.com/", // URL to the source or more information about the update
        "sha256checksum": "", // SHA-256 checksum for verifying the integrity of the downloaded file (optional)
        "minSupport": 1 // Minimum supported version code; devices with a lower version code will be forced to update
    },

    "ios": {
        "versionCode": 2, // Integer representing the new version code for iOS
        "versionName": "1.1.0", // String representing the new version name for iOS
        "changeLog": "- Bug fixes and performance improvements. \n- new ui", // Change log for iOS version
        "sourceUrl": "https://example.com/", // URL for more information or source for the iOS update
        "minSupport": 1 // Minimum supported version code for iOS
    },

    "windows": {
        "versionCode": 34, // Integer representing the new version code for Windows
        "versionName": "5.0.0", // String representing the new version name for Windows
        "downloadUrl": "https://example.com/UdateCenter/app-windows.exe", // URL to download the new Windows application
        "changeLog": "- Bug fixes and performance improvements. \n- New Icon;", // Change log for the Windows version
        "sourceUrl": "https://example.com/", // URL for more information or source for the Windows update
        "sha256checksum": "", // SHA-256 checksum for the Windows file (optional)
        "minSupport": 14 // Minimum supported version code for Windows
    }
}

```
# Example of plugin initialization and configuration

## First you need to give permissions in the Android Manifest to read files and install apk files.

Paste these lines into the file if you don't have them.

```xml
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## Now initialize the plugin in your file, preferably in initState.

```dart
  late UpdateCenter updateCenter;

@override
void initState() {
  initializeUpdateCenter();
  super.initState();
}
```

## Full plugin settings.

```dart
import 'package:flutter/material.dart';
import 'package:update_center/update_center.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UpdateCenter updateCenter;

  @override
  void initState() {
    initializeUpdateCenter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Update Center v1.0.0-alpha.1'),
        ),
        body: Center(
                child: OutlinedButton(
                  onPressed: () => checkUpdate(), // You can check for updates using the button
                  child: const Text('Check update'),
                )),
      ),
    );
  }

  void initializeUpdateCenter() {
    // Main plugin settings
    updateCenter = UpdateCenter(
      context: context,
      urlJson: 'https://example.com/UpdateCenter/update_center.json', // URL to get JSON data for updates (replace with yours)
      versionName: '', // Name of the current version of your application (You can fill it with any text or leave it so that the data is shown from the json file)
      changeLog: '', // Same here as versionName

      // Plugin configuration (You can embed your own translation configuration so that the plugin looks harmonious with your application.)
      config: UpdateCenterConfig(
        // Global Configuration
        isCheckStart: true, // Whether to check for updates when the app starts
        isNoUpdateAvailableToast: true, // Whether to show a toast message if no updates are available

        // Alert Dialog and BottomSheet Configuration
        updateButtonText: 'Install', // Text for the update button
        skipButtonText: 'Later', // Text for the skip button
        updateAvailableText: 'Update available', // Text indicating an update is available
        changelogText: 'Changelog', // Text for the changelog section
        titleDownloadBottomSheets: 'Downloading...', // Title text for the downloading bottom sheet
        iconBottomSheet: const Icon(Icons.downloading_outlined, color: Colors.grey), // Icon for the bottom sheet
        dialogType: DialogType.bottomSheet, // Type of dialog to show for updates (alert dialog or bottom sheet)

        //Custom text style (Uncomment to apply them)
        // alertChangeLogStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        // alertVersionNameStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        // bottomSheetChangeLogStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        // bottomSheetVersionNameStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

        // Notification Configuration
        defaultIcon: '@drawable/ic_update_center', // Icon for the notification (Replace the path with another icon)
        downloadProgressNotificationTextTitle: 'Download update', // At the end of the line, the new version extracted from the json file will be shown. The text will be "Download update 1.0.3"
        downloadProgressNotificationTextBody: 'Downloading update...', // Body text for the download progress notification
        showProgress: true, // Whether to show download progress in the notification
        channelShowBadge: false, // Whether to show a badge on the notification channel

        // Notification Configuration for Failed Download
        downloadFailedNotificationTitleText: 'Failed download update', // Title for the failed download notification
        downloadFailedNotificationBodyText: 'An error occurred while downloading update. Check your internet connections and try again', // Body text for the failed download notification
      ),
    );
  }

  //Check for updates
  checkUpdate() async {
    await updateCenter.check();
  }
}

```