import 'package:habbits_manager/domain/enums/alarm_type.dart';

extension ParseToString on AlarmType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
