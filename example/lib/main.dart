import 'package:flutter/material.dart';
import 'package:update_center/update_center.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyApp()));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Center v1.0.0-alpha.3'),
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
      urlJson:
          'https://example.com/UpdateCenter/update_center.json', // URL to get JSON data for updates (replace with yours)
      versionName: '', // Name of the current version of your application (You can fill it with any text or leave it so that the data is shown from the json file)
      changeLog: '', // Same here as versionName

      // Plugin configuration (You can embed your own translation configuration so that the plugin looks harmonious with your application.)
      config: UpdateCenterConfig(
        // Global Configuration
        isCheckStart: true, // Whether to check for updates when the app starts
        isNoUpdateAvailableToast: true, // Whether to show a toast message if no updates are available
        isSourceUrl: false, // You can enable clicking a link instead of downloading a file.

        // Alert Dialog and BottomSheet Configuration
        updateButtonText: 'Install', // Text for the update button
        skipButtonText: 'Later', // Text for the skip button
        updateAvailableText:
            'Update available', // Text indicating an update is available
        changelogText: 'Changelog', // Text for the changelog section
        titleDownloadBottomSheets:
            'Downloading...', // Title text for the downloading bottom sheet
        customIconTitle: const Icon(
          Icons.downloading_outlined,
          color: Colors.grey,
          size: 40,
        ), // Icon for the bottom sheet

        dialogType: DialogType.bottomSheet, // Type of dialog to show for updates (alert dialog or bottom sheet)

        //Custom text style (Uncomment to apply them)
        // alertChangeLogStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        // alertVersionNameStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        // bottomSheetChangeLogStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        // bottomSheetVersionNameStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

        // Notification Configuration
        defaultIcon: '@drawable/ic_update_center', // Icon for the notification (Replace the path with another icon)
        downloadProgressNotificationTextTitle: 'Download update', // Title header in notification
        downloadProgressNotificationTextBody: 'Downloading update...', // Body text for the download progress notification
        showProgress: true, // Whether to show download progress in the notification
        channelShowBadge: false, // Whether to show a badge on the notification channel

        // Notification Configuration for Failed Download
        downloadFailedNotificationTitleText:
            'Failed download update', // Title for the failed download notification
        downloadFailedNotificationBodyText:
            'An error occurred while downloading update. Check your internet connections and try again', // Body text for the failed download notification
      ),
    );
  }

  //Check for updates
  checkUpdate() async {
    await updateCenter.check();
  }
}
