import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:update_center/update_center.dart';

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

  @override
  void initState() {
    initializeUpdateCenter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Center v1.0.0-alpha.4'),
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
        urlJson: 'https://api.sunsetgram.com/v1/UpdateCenter/update_center.json', // URL to get JSON data for updates (replace with yours)

        // Plugin configuration (You can embed your own translation configuration so that the plugin looks harmonious with your application.)
        config: UpdateCenterConfig(

            globalConfig: GlobalConfig(
              isCheckStart: true, // Whether to check for updates when the app starts
              isNoUpdateAvailableToast: true, // Whether to show a toast message if no updates are available
              isSourceUrl: false, // You can enable clicking a link instead of downloading a file
              isVerifiedSha256Android: true, // Responsible for enabling sha256 checks after the file is downloaded
              isVerifiedSha256Windows: true, // Responsible for enabling sha256 checks after the file is downloaded
              isRequestForNotifications: true // Allows you to request notifications or not
            ),

            uiConfig: UIConfig(

              updateButtonText: 'Install', // Text for the update button
              skipButtonText: 'Later', // Text for the skip button
              updateAvailableText: 'Update available', // Text indicating an update is available
              changelogText: 'Changelog', // Text for the changelog section
              titleDownloadBottomSheets: 'Downloading...', // Title text for the downloading bottom sheet
              titleVerifiedSha256BottomSheets: 'Verified sha256...', // Header text for hash check bottom sheet 256
              toastNoUpdateFoundText: 'No update found',

              // Custom text style (Uncomment to apply them)
              alertChangeLogTextStyle: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              alertVersionNameStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              bottomSheetChangeLogTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              bottomSheetVersionNameTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

              customIconTitle: const Icon(Icons.downloading_outlined, size: 26,), // Icon for the bottom sheet
              dialogType: DialogType.bottomSheet, // Type of dialog to show for updates (alert dialog or bottom sheet)
            ),

            notificationConfig: NotificationConfig(
              defaultIcon: '@drawable/ic_update_center', // Icon for the notification (Replace the path with another icon)
              downloadProgressNotificationTextTitle: 'Downloading...', // Title header in notification
              downloadProgressNotificationTextBody: '',  // Body text for the download progress notification
              downloadFailedNotificationTitleText: 'Download failed', // Title for the failed download notification
              downloadFailedNotificationBodyText: 'An error occurred while downloading update. Check your internet connections and try again', // Body text for the failed download notification
              verifiedSha256NotificationTitleText: 'Verified sha256',
              verifiedSha256NotificationBodyText: '',

              showProgress: true,  // Whether to show download progress in the notification
              channelShowBadge: true, // Whether to show a badge on the notification channel
            )

        )
    );
  }

  //Check for updates
  checkUpdate() async {
    await updateCenter.check();
  }
}
