import 'package:talker/talker.dart';
import 'package:update_center/config/config.dart';

class TalkerProvider {
  final Talker talker;

  TalkerProvider(UpdateCenterConfig config)
      : talker = Talker(
          settings: TalkerSettings(
            enabled: config.globalConfig.isEnabledLog,
          ),
        );
}
