import 'package:habbits_manager/infrastructure/daos/alarm_dao.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_alarm_repository.dart';

class AlarmDatabaseRepository implements AlarmRepository {
  final dao = AlarmDao();
  @override
  DatabaseProvider databaseProvider;

  AlarmDatabaseRepository(this.databaseProvider);

  @override
  Future<Alarm> getAlarmById(int id) async {
    final db = await databaseProvider.db();
    var result = await db
        .query(dao.tableName, where: dao.columnId + " = ?", whereArgs: [id]);
    if (result == null || result.isEmpty) {
      return null;
    } else {
      return dao.fromMap(result.first);
    }
  }

  @override
  Future<List<Alarm>> getAllAlarms() async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromMapToList(maps);
  }

  @override
  Future<int> insert(Alarm alarm) async {
    final db = await databaseProvider.db();
    var alarmId = await db.insert(dao.tableName, dao.toMap(alarm));
    return alarmId;
  }

  @override
  Future<int> update(Alarm alarm) async {
    final db = await databaseProvider.db();
    var alarmId = await db.update(dao.tableName, dao.toMap(alarm),
        where: dao.columnId + " = ?", whereArgs: [alarm.id]);
    return alarmId;
  }

  @override
  Future<int> delete(int id) async {
    final db = await databaseProvider.db();
    var alarmId = await db
        .delete(dao.tableName, where: dao.columnId + " = ?", whereArgs: [id]);
    return alarmId;
  }
}
