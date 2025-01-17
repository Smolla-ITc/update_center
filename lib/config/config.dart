import '../utils/constants.dart';

/// Global Configuration for the plugin
class GlobalConfig {
  final bool checkStart;
  final bool noUpdateAvailableToast;
  final bool sourceUrl;
  final bool openingFile;
  final AndroidDialogBuilder? androidDialogBuilder;
  final WindowsDialogBuilder? windowsDialogBuilder;
  final NoUpdateAvailableBuilder? androidNoUpdateAvailableBuilder;
  final NoUpdateAvailableBuilder? windowsNoUpdateAvailableBuilder;

  GlobalConfig({
    this.checkStart = false,
    this.noUpdateAvailableToast = false,
    this.sourceUrl = false,
    this.openingFile = false,
    this.androidDialogBuilder,
    this.windowsDialogBuilder,
    this.androidNoUpdateAvailableBuilder,
    this.windowsNoUpdateAvailableBuilder,
  });
}

/// Config for the plugin
class UpdateCenterConfig {
  final GlobalConfig globalConfig;

  UpdateCenterConfig({
    required this.globalConfig,
  });
}
