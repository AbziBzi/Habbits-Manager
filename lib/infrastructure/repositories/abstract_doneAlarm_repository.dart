import 'package:habbits_manager/domain/models/doneAlarm.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';

abstract class DoneAlarmRepository {
  DatabaseProvider databaseProvider;

  Future<int> insert(DoneAlarm doneAlarm);
  Future<DoneAlarm> getHabbitById(int id);
  Future<List<DoneAlarm>> getAllDoneAlarms();
  Future<List<DoneAlarm>> getAllHabitDoneAlarms(int habbitId);
}
