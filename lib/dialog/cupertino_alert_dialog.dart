import 'package:flutter/cupertino.dart';
import '../config/config.dart';

/// Dialog used to display updates for iOS
class CupertinoDialog extends StatelessWidget {

  final String versionName;

  final String changeLog;

  final bool allowSkip;

  final VoidCallback onUpdate; // Callback for the update action

  final VoidCallback onSkip; // Callback for the skip action

  final UpdateCenterConfig config;

  const CupertinoDialog({
    super.key,
    required this.versionName,
    required this.changeLog,
    this.allowSkip = true,
    required this.onUpdate,
    required this.onSkip,
    required this.config
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: allowSkip,
      child: CupertinoAlertDialog(
        title: Text(versionName, style: config.alertVersionNameStyle,),
        content: Text(changeLog, style: config.alertChangeLogTextStyle,),
        actions: <CupertinoDialogAction>[
          if(allowSkip)
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onSkip,
            child: Text(config.skipButtonText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: onUpdate,
            child: Text(config.updateButtonText),
          ),
        ],
      ),
    );
  }
}