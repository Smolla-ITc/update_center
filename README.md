# ![UpdateCenter Icon](https://raw.githubusercontent.com/Smolla-ITc/update_center/main/assets/ic_uc.png) Update Center
[![Pub Version](https://img.shields.io/pub/v/update_center?color=orange)](https://pub.dev/packages/update_center)

## Flutter plugin that allows you to implement multi-check for updates for different platforms Android, Windows.

# What has been implemented so far.

- Create your own dialogues to suit your style.
- Automatic update check depending on the platform the plugin runs on.
- The plugin can prevent skipping an update if the json code is higher than the local version code, preventing the dialog from closing.
- The plugin can work with downloaded files. They will be deleted after the update is completed. Or if the user has not updated and by this time an update has been released, the plugin will delete the old file and download a new one, rather than start a new download and immediately open the file for update. This works on both Android and Windows. Download files are stored in Windows directories - the download folder “/Update Center/”. Android - memory cache folder. But soon the plugin itself will determine where to save the files depending on the importance of the update.
- Once the download is complete, the files themselves open in supported formats. In Windows zip and exe and also any file. And Android is similar.
- And there is also flexible customization of the plugin, see example below. These are not all the settings many more settings will be added in the future.

# Getting started

The plugin works with a Json file so make sure you have somewhere to place this file.

### Add package to your pubspec.yaml

```yaml
dependencies:
  update_center: ^2.0.1
```

## Json file structure

```json
{
  "android": {
    "versionName": "1.1.0",
    "downloadUrl": "https://example.com/UpdateCenter/app.apk",
    "changeLog": "- bug fixed; \n- new ui;",
    "sourceUrl": "https://example.com/",
    "versionCode": 2,
    "minSupport": 1
  },

  "windows": {
    "versionName": "5.0.0",
    "downloadUrl": "https://example.com/UpdateCenter/app-windows.exe",
    "changeLog": "- Bug fixes and performance improvements. \n- New Icon;",
    "sourceUrl": "https://example.com/",
    "versionCode": 2,
    "minSupport": 14
  }
}
```
## Description of the json structure

```txt
{
    "android": {
        "versionName": "1.1.0", // String representing the new version name for Android
        "downloadUrl": "https://example.com/UpdateCenter/app.apk", // URL to download the new Android APK
        "changeLog": "- bug fixed; \n- new ui;", // Change log detailing what's new or fixed in this version
        "sourceUrl": "https://example.com/", // URL to the source or more information about the update
        "versionCode": 2, // Integer representing the new version code for Android
        "minSupport": 1 // Minimum supported version code; devices with a lower version code will be forced to update
    },

    "windows": {
        "versionName": "5.0.0", // String representing the new version name for Windows
        "downloadUrl": "https://example.com/UpdateCenter/app-windows.exe", // URL to download the new Windows application
        "changeLog": "- Bug fixes and performance improvements. \n- New Icon;", // Change log for the Windows version
        "sourceUrl": "https://example.com/", // URL for more information or source for the Windows update
        "versionCode": 34, // Integer representing the new version code for Windows 
        "minSupport": 14 // Minimum supported version code for Windows
    }
}

```
# Example of plugin initialization and configuration

## First you need to give permissions in the Android Manifest to read files and install apk files.

Paste these lines into the file if you don't have them.

```xml
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>
```

## Full plugin settings.

Go to main file at this [link](https://github.com/Smolla-ITc/update_center/blob/main/example/lib/main.dart) to find out more.