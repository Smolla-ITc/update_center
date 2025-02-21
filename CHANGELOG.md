## 2.0.2
- Updated dependencies

## 2.0.1
- Fixed Readme.

## 2.0.0

# Major update
- iOS support removed.
- Notification support removed.
- Updated dependencies.
- Fixed minor bugs.
- Other minor updates.

## 1.0.3
- Updated dependencies

## 1.0.2
- Fixed notifications
- Updated dependencies

## 1.0.0
# Release plugin
- Rename name package to org.smollaitc.
- Updated dependencies.
- Fixed "null check operator used on a null value" in Windows and Android boot method.
- License updated.

## 1.0.0-beta.2+2

- Fixed display of widget "isNoUpdateAvailableToast".

## 1.0.0-beta.2+1

- Update dependencies.

## 1.0.0-beta.2

### *ATTENTION! There are a lot of breaking changes in this update!!*

#### **Strong changes or Additions**
- The most important change is that now you can make your own dialogues or whatever you want right in the config! this will allow you to make better integration with your application!.
- Now you can add a notification that the update is not available right now just like dialogs through the config.

#### **Normal changes**
- The code has been slightly refactored.
- The structure of the json model has been slightly changed.
- Talker logger plugin removed.
- Removed sha256 check because it does not work correctly.
- Libraries updated.

## 1.0.0-beta.1

* Added utf-8 encoding
* The json model order has been slightly changed
* Added custom log (talker 4.0.0)
* Updated some dependencies
* Update readme

## 1.0.0-alpha.5

* Changed the way version data is stored to SharedPreferences
* Readme updated
* Minor code refactoring
* Added ```isOpenFile``` flag
* Other small fixes

## 1.0.0-alpha.4

* Replaced license for Apache 2.0
* Delete topic
* Added support for checking sha256 after downloading files on both Android and Windows. On Windows, to use hash 256 checks, you need to use files that support different hashes, these are mainly installation files like exe and the like zip rar and other archives will not support hashes. Therefore, if you use archives for updating, then in the config you can disable this for Windows separately so that after downloading there is no hash check.
* Config refactoring - now the config is divided into 3 categories: ```globalConfig```, ```uiConfig```, ```notificationConfig```
* Added a request to show notifications but you can disable this if you do not want to make requests
* Notifications have been refactored and there is now less code
* Now after the update, files on Windows will be deleted in the same way as on Android.
* Now, if the file has already been downloaded and the user has not updated to the next update, the plugin will delete the old file and download the new one. And also the plugin will not allow you to start the download again, but will open the file for updating. It works on both Windows and Android.
* Update README.md

## 1.0.0-alpha.3

* Added ```SourceUrl``` value. If set to true, the link specified in the json file will be followed
* Added loading window for ```alertDialog``` will show ```downloadBottomSheet```
* Fixed download notifications: ```versionName``` will not be shown in the title at the end of the line. the version will be shown in subTitle
* Fixed loading indicator in ```DownloadProgressBottomSheets```
* Update Readme
* Other fixes and improvements

## 1.0.0-alpha.2+2

* Update Readme
* Add Screenshots

## 1.0.0-alpha.2+1

* Update ```environment``` in pubspec.yaml

## 1.0.0-alpha.2

* Update Readme
* Optimizing the plugin page for pub.dev

## 1.0.0-alpha.1

* Init alpha release