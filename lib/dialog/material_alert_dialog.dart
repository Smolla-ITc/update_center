import 'package:flutter/material.dart';
import '../config/config.dart';

/// Alert dialog material is used to display the update
class MaterialAlertDialog extends StatelessWidget {
  final String versionName;

  final String changeLog;

  final bool allowSkip;

  final VoidCallback onUpdate; // Callback for the update action

  final VoidCallback onSkip; // Callback for the skip action

  final UpdateCenterConfig config;

  const MaterialAlertDialog(
      {super.key,
      required this.versionName,
      required this.changeLog,
      this.allowSkip = true,
      required this.onUpdate,
      required this.onSkip,
      required this.config});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: allowSkip,
      child: AlertDialog(
        scrollable: true,
        icon: config.uiConfig.customIconTitle,
        title: Text(versionName,
            textAlign: TextAlign.center, style: config.uiConfig.alertVersionNameStyle),
        content: Text(
          changeLog,
          textAlign: TextAlign.start,
          style: config.uiConfig.alertChangeLogTextStyle,
        ),
        actions: <Widget>[
          if (allowSkip)
            TextButton(
              onPressed: onSkip,
              child: Text(config.uiConfig.skipButtonText),
            ),
          FilledButton(
            onPressed: onUpdate,
            child: Text(config.uiConfig.updateButtonText),
          ),
        ],
      ),
    );
  }
}
