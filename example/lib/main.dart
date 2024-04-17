import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:update_center/update_center.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    // You don't have to do this to test Material dialogs
    DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: darkDynamic,
          ),
          home: const MyApp());
    }),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UpdateCenter updateCenter;

  static const String _apiUrl =
      'https://example.com/UpdateCenter/update_center.json';

  _launchURL(String sourceUrl) async {
    final Uri url = Uri.parse(sourceUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $sourceUrl');
    }
  }

  @override
  void initState() {
    initializeUpdateCenter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Center v1.0.0-beta.2'),
      ),
      body: Center(
          child: OutlinedButton(
        onPressed: () =>
            checkUpdate(), // You can check for updates using the button
        child: const Text('Check update'),
      )),
    );
  }

  void initializeUpdateCenter() {

    // Main plugin settings
    updateCenter = UpdateCenter(
        context: context,
        urlJson: _apiUrl, // URL to get JSON data for updates (replace with yours)

        config: UpdateCenterConfig(
            globalConfig: GlobalConfig(
                isCheckStart: true, // Whether to check for updates when the app starts
                isNoUpdateAvailableToast: true, // Whether to show a toast message if no updates are available
                isSourceUrl: false, // You can enable clicking a link instead of downloading a file
                isRequestForNotifications: true, // Allows you to request notifications or not
                isOpenFile: true, // Determines whether to open an already downloaded file instead of downloading it again (This can be useful if you don't want users to download the file again)

                // Widgets for displaying a notification about the unavailability of an update
                androidNoUpdateAvailableBuilder: (BuildContext context) {
                  Fluttertoast.showToast(msg: 'No updates found');
                },
                iosNoUpdateAvailableBuilder: (BuildContext context) {
                  Fluttertoast.showToast(msg: 'No updates found');
                },
                windowsNoUpdateAvailableBuilder: (BuildContext context) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No updates found'),
                    duration: Duration(seconds: 2),
                  ));
                },

                // Constructors of dialogs or widgets for each platform to display the update itself.
                androidDialogBuilder: (BuildContext context,
                    AndroidModel model,
                    UpdateCenterConfig config,
                    DownloadState downloadState,
                    bool allowSkip) {
                  return showDialog(
                    context: context,
                    barrierDismissible: allowSkip,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(model.versionName),
                        content: Text(model.changeLog),
                        actions: [
                          if (allowSkip)
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Close"),
                            ),

                          // Changes state to show loading percentage
                          ValueListenableBuilder<bool>(
                            valueListenable: downloadState.isDownloading,
                            builder: (context, isDownloading, child) {
                              return TextButton(
                                onPressed: isDownloading
                                    ? null
                                    : () async {
                                        downloadState.isDownloading.value =
                                            false;
                                        // Ensure the button does nothing while downloading
                                        await OnDownload.initiateUpdate(
                                          url: model.downloadUrl,
                                          versionName: model.versionName,
                                          config: config,
                                          downloadState: downloadState,
                                          sourceUrl: model.sourceUrl,
                                          launchUrl: (url) => _launchURL(url),
                                        );
                                      },
                                child: isDownloading
                                    ? ValueListenableBuilder<double>(
                                        valueListenable: downloadState.progress,
                                        builder: (context, progress, _) {
                                          int progressValue =
                                              (progress * 100).toInt();
                                          return AnimatedFlipCounter(
                                            suffix: '%',
                                            duration: const Duration(
                                                milliseconds: 500),
                                            value: progressValue,
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                          );
                                        },
                                      )
                                    : const Text('Download'),
                              );
                            },
                          )
                        ],
                      );
                    },
                  );
                },
                iosDialogBuilder: (BuildContext context,
                    IOSModel model,
                    UpdateCenterConfig config,
                    DownloadState downloadState,
                    bool allowSkip) {
                  return showDialog(
                      context: context,
                      barrierDismissible: allowSkip,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text(model.versionName),
                          content: Text(model.changeLog),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: const Text("Close"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            CupertinoDialogAction(
                              onPressed: () => _launchURL(model.sourceUrl),
                              child: const Text("Open to url"),
                            ),
                          ],
                        );
                      });
                },
                windowsDialogBuilder: (BuildContext context,
                    WindowsModel model,
                    UpdateCenterConfig config,
                    DownloadState downloadState,
                    bool allowSkip) {
                  return showDialog(
                    context: context,
                    barrierDismissible: allowSkip,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(model.versionName),
                        content: Text(model.changeLog),
                        actions: [
                          if (allowSkip)
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Close"),
                            ),

                          // Changes state to show loading percentage
                          ValueListenableBuilder<bool>(
                            valueListenable: downloadState.isDownloading,
                            builder: (context, isDownloading, child) {
                              return TextButton(
                                onPressed: isDownloading
                                    ? null
                                    : () async {
                                        // Disables the button so it doesn't cause new load calls when clicked
                                        downloadState.isDownloading.value = false;

                                        // Download call
                                        await OnDownload.initiateUpdate(
                                          url: model.downloadUrl,
                                          versionName: model.versionName,
                                          config: config,
                                          downloadState: downloadState,
                                          sourceUrl: model.sourceUrl,
                                          launchUrl: (url) => _launchURL(url),
                                        );
                                      },
                                child: isDownloading
                                    ? ValueListenableBuilder<double>(
                                        valueListenable: downloadState.progress,
                                        builder: (context, progress, _) {
                                          int progressValue =
                                              (progress * 100).toInt();
                                          return AnimatedFlipCounter(
                                            suffix: '%',
                                            duration: const Duration(
                                                milliseconds: 500),
                                            value: progressValue,
                                            textStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                          );
                                        },
                                      )
                                    : const Text('Download'),
                              );
                            },
                          )
                        ],
                      );
                    },
                  );
                }),

            notificationConfig: NotificationConfig(
              defaultIcon: '@drawable/ic_update_center', // Icon for the notification (Replace the path with another icon)
              downloadProgressNotificationTextTitle: 'Downloading...', // Title header in notification
              downloadProgressNotificationTextBody: '', // Body text for the download progress notification
              downloadFailedNotificationTitleText: 'Download failed', // Title for the failed download notification
              downloadFailedNotificationBodyText: 'An error occurred while downloading update. Check your internet connections and try again', // Body text for the failed download notification

              showProgress: true, // Whether to show download progress in the notification
              channelShowBadge: true, // Whether to show a badge on the notification channel
            )));
  }

  //Check for updates
  checkUpdate() async {
    await updateCenter.check();
  }
}
