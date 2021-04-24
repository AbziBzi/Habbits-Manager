import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/domain/models/doneAlarm.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_doneAlarm_repository.dart';
import 'package:habbits_manager/infrastructure/daos/doneAlarm_dao.dart';

class DoneAlarmDatabaseRepository implements DoneAlarmRepository {
  final dao = DoneAlarmDao();
  @override
  DatabaseProvider databaseProvider;

  DoneAlarmDatabaseRepository(this.databaseProvider);

  @override
  Future<List<DoneAlarm>> getAllDoneAlarms() async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromMapToList(maps);
  }

  @override
  Future<List<DoneAlarm>> getAllHabitDoneAlarms(int habbitId) async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName,
        where: dao.columnHabitId + " = ?", whereArgs: [habbitId]);
    return dao.fromMapToList(maps);
  }

  @override
  Future<DoneAlarm> getHabbitById(int id) async {
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
  Future<int> insert(DoneAlarm doneAlarm) async {
    final db = await databaseProvider.db();
    var doneAlarmId = await db.insert(dao.tableName, dao.toMap(doneAlarm));
    return doneAlarmId;
  }
}
