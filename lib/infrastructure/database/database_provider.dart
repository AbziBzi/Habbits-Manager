import 'package:habbits_manager/infrastructure/daos/alarm_dao.dart';
import 'package:habbits_manager/infrastructure/daos/goal_dao.dart';
import 'package:habbits_manager/infrastructure/daos/habbit_dao.dart';
import 'package:habbits_manager/infrastructure/daos/doneAlarm_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final _instance = DatabaseProvider._internal();
  static DatabaseProvider get = _instance;
  bool isInitialized = false;
  Database _db;

  DatabaseProvider._internal();

  Future<Database> db() async {
    if (!isInitialized) await _init();
    return _db;
  }

  Future _init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'habbits_manager.db');

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(GoalDao().createTableQuery);
      await db.execute(AlarmDao().createTableQuery);
      await db.execute(HabbitDao().createTableQuery);
      await db.execute(DoneAlarmDao().createTableQuery);
    });
  }
}
