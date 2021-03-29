import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';

abstract class AlarmRepository {
  DatabaseProvider databaseProvider;

  Future<int> insert(Alarm alarm);
  Future<int> update(Alarm alarm);
  Future<int> delete(int id);
  Future<Alarm> getAlarmById(int id);
  Future<List<Alarm>> getAllAlarms();
}
