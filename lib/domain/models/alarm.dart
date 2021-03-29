import 'package:habbits_manager/domain/enums/alarm_type.dart';

class Alarm {
  int id;
  DateTime dateTime;
  AlarmType alarmType;

  Alarm({this.id, this.dateTime, this.alarmType});
}
