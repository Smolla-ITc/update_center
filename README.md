# ![UpdateCenter Icon](https://raw.githubusercontent.com/Smolla-ITc/update_center/main/assets/ic_uc.png) Update Center
[![Pub Version](https://img.shields.io/pub/v/update_center?color=orange)](https://pub.dev/packages/update_center)

## Flutter plugin that allows you to implement multi-check for updates for different platforms Android, IOS, Windows.

# IMPORTANT INFORMATION! ⚠

## This plugin is under active development and many features have not yet been implemented. The plugin now works well with Android and Windows, you can now use the plugin for these platforms. IOS is partially implemented, but it can also work, but improvements are needed. If you use fluent_ui (Windows), then the plugin does not yet support this feature, perhaps it will be added later. I was not able to check the functionality of the IOS plugin, since I do not have access to an iPhone or Mac Book, but in theory it should work, you can just check the functionality of the IOS plugin in your project and if you find errors, write to this email smollaitc.support@sunsetgram.com or add a comment to the problems in the github project https://github.com/Smolla-ITc/update_center/issues.
# What has been implemented so far.

- Automatic update check depending on the platform the plugin runs on.
- Show notifications about download progress and download errors (The plugin does not yet know how to issue a notification request this will be added in subsequent updates).
- The plugin may prohibit skipping an update if the code in json is higher than the local versionCode, preventing the dialog or bottom sheet from being closed.
- The plugin can work with downloaded files. They will be deleted after the update is complete. Or if the user has not updated and by this time an update has been released, then the plugin will delete the old file and upload a new one and also it will not start a new download and will immediately open the file for updating. This works on both Android and Windows. Download files are stored in Windows directories - the download folder “/Update Center/”. Android - internal memory.
- Once the download is complete, the files themselves open in supported formats. In Windows zip and exe and also any file. And Android is similar.
- And there is also flexible customization of the plugin, see example below. These are not all the settings many more settings will be added in the future.
- Support hash check 256 after downloading a file.

## Screenshots android (Windows is identical to android)
<img src="https://raw.githubusercontent.com/Smolla-ITc/update_center/main/assets/scr-alert-dialog-m3.png" width="300" alt="image-alert-dialog-m3"/> <img src="https://raw.githubusercontent.com/Smolla-ITc/update_center/main/assets/scr-bottom-sheet-m3.png" width="300" alt="image-bottom-sheet-m3"/> <img src="https://raw.githubusercontent.com/Smolla-ITc/update_center/main/assets/scr-download-bottom-shet-m3.png" width="300" alt="image-download-bottom-sheet-m3"/> <img src="https://raw.githubusercontent.com/Smolla-ITc/update_center/main/assets/scr-verifiedSha256-bottom-shet-m3.png" width="300" alt="image-verifiedSha256-bottom-sheet-m3"/>

# Getting started

The plugin works with a Json file so make sure you have somewhere to place this file.

### Add package to your pubspec.yaml

```yaml
dependencies:
  update_center: ^1.0.0-alpha.5
```

## Json file structure

```json
{
  "android": {
    "versionCode": 2,
    "versionName": "1.1.0",
    "downloadUrl": "https://example.com/UpdateCenter/app.apk",
    "changeLog": "- bug fixed; \n- new ui;",
    "sourceUrl": "https://example.com/",
    "sha256checksum": "191bca0b245e3c5553375fd232ee7790b08068e9c5bf7c5a8277416cbf6f99cd",
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
    "versionCode": 2,
    "versionName": "5.0.0",
    "downloadUrl": "https://example.com/UpdateCenter/app-windows.exe",
    "changeLog": "- Bug fixes and performance improvements. \n- New Icon;",
    "sourceUrl": "https://example.com/",
    "sha256checksum": "ffecd22303245e714739429280c7e91deade14b28957dd6413cce938239cd275",
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
        "downloadUrl": "https://example.com/UpdateCenter/app.apk", // URL to download the new Android APK
        "changeLog": "- bug fixed; \n- new ui;", // Change log detailing what's new or fixed in this version
        "sourceUrl": "https://example.com/", // URL to the source or more information about the update
        "sha256checksum": "191bca0b245e3c5553375fd232ee7790b08068e9c5bf7c5a8277416cbf6f99cd", // SHA-256 checksum for verifying the integrity of the downloaded file (optional)
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
        "downloadUrl": "https://example.com/UpdateCenter/app-windows.exe", // URL to download the new Windows application
        "changeLog": "- Bug fixes and performance improvements. \n- New Icon;", // Change log for the Windows version
        "sourceUrl": "https://example.com/", // URL for more information or source for the Windows update
        "sha256checksum": "ffecd22303245e714739429280c7e91deade14b28957dd6413cce938239cd275", // SHA-256 checksum for the Windows file (optional)
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

## Full plugin settings.

Go to main file at this [link](https://github.com/Smolla-ITc/update_center/blob/main/example/lib/main.dart) to find out more