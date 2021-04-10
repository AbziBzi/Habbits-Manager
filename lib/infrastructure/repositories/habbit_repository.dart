import 'package:habbits_manager/infrastructure/daos/habbit_dao.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/alarm_repository.dart';

class HabbitDatabaseRepository implements HabbitRepository {
  final dao = HabbitDao();
  final AlarmDatabaseRepository _alarmRepository;

  @override
  DatabaseProvider databaseProvider;

  HabbitDatabaseRepository(this.databaseProvider, this._alarmRepository);

  @override
  Future<Habbit> getHabbitById(int id) async {
    final db = await databaseProvider.db();
    var result = await db
        .query(dao.tableName, where: dao.columnId + " = ?", whereArgs: [id]);
    if (result == null || result.isEmpty) {
      return null;
    } else {
      Habbit habbit = dao.fromMap(result.first);
      if (habbit.alarmId != null) {
        var habbitAlarms = await _alarmRepository.getAlarmById(habbit.alarmId);
        if (habbitAlarms != null) {
          habbit.alarm = habbitAlarms;
        }
      }
      return habbit;
    }
  }

  @override
  Future<List<Habbit>> getAllHabbits() async {
    final db = await databaseProvider.db();
    List<Map> result = await db.query(dao.tableName);
    if (result == null || result.isEmpty) {
      return null;
    } else {
      List<Habbit> habbits = dao.fromMapToList(result);
      for (int i = 0; i < habbits.length; i++) {
        if (habbits[i].alarmId != null) {
          var habbitAlarms =
              await _alarmRepository.getAlarmById(habbits[i].alarmId);
          if (habbitAlarms != null) {
            habbits[i].alarm = habbitAlarms;
          }
        }
      }
      return habbits;
    }
  }

  @override
  Future<int> insert(Habbit habbit) async {
    final db = await databaseProvider.db();
    var habbitId = await db.insert(dao.tableName, dao.toMap(habbit));
    return habbitId;
  }

  @override
  Future<int> update(Habbit habbit) async {
    final db = await databaseProvider.db();
    var habbitId = await db.update(dao.tableName, dao.toMap(habbit),
        where: dao.columnId + " = ?", whereArgs: [habbit.id]);
    return habbitId;
  }

  @override
  Future<int> delete(int id) async {
    final db = await databaseProvider.db();
    var habbitId = await db
        .delete(dao.tableName, where: dao.columnId + " = ?", whereArgs: [id]);
    return habbitId;
  }

  @override
  Future<List<Habbit>> getAllGoalHabbits(int goalId) async {
    final db = await databaseProvider.db();
    var result = await db.query(dao.tableName,
        where: dao.columnGoalId + " = ?", whereArgs: [goalId]);
    if (result == null || result.isEmpty) {
      return null;
    } else {
      List<Habbit> habbits = dao.fromMapToList(result);
      for (int i = 0; i < habbits.length; i++) {
        if (habbits[i].alarmId != null) {
          var habbitAlarms =
              await _alarmRepository.getAlarmById(habbits[i].alarmId);
          if (habbitAlarms != null) {
            habbits[i].alarm = habbitAlarms;
          }
        }
      }
      return habbits;
    }
  }
}
