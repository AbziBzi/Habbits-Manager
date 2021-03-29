import 'package:habbits_manager/domain/models/alarm.dart';

class Habbit {
  int id;
  String name;
  String description;
  DateTime creationDate;
  int goalId;
  int alarmId;
  Alarm alarm;

  Habbit(
      {this.id,
      this.name,
      this.description,
      this.creationDate,
      this.goalId,
      this.alarmId,
      this.alarm});
}
