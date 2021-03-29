import 'package:habbits_manager/domain/enums/alarm_type.dart';

extension ParseToEnum on String {
  AlarmType toAlarmType() {
    return AlarmType.values.firstWhere(
        (e) => e.toString().toLowerCase() == 'AlarmType.$this'.toLowerCase(),
        orElse: () => null);
  }
}
