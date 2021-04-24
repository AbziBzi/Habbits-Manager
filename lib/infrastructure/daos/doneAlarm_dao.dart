import 'package:habbits_manager/domain/models/doneAlarm.dart';
import 'package:habbits_manager/infrastructure/daos/abstract_dao.dart';
import 'package:habbits_manager/utils/int_bool_extensions.dart';

class DoneAlarmDao implements Dao<DoneAlarm> {
  final tableName = 'doneAlarms';
  final columnId = 'id';
  final columnHabitId = 'habitId';
  final _columnCreationDate = 'creationDate';
  final _columnIsScanned = 'isScanned';
  final _columnReason = 'reason';

  @override
  String get createTableQuery => "CREATE TABLE $tableName("
      " $columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      " $columnHabitId INTEGER NOT NULL,"
      " $_columnCreationDate INTEGER NOT NULL,"
      " $_columnIsScanned INTAGER NOT NULL,"
      " $_columnReason TEXT NOT NULL"
      ")";

  @override
  List<DoneAlarm> fromMapToList(List<Map<String, dynamic>> query) {
    List<DoneAlarm> doneAlarms = [];
    for (Map map in query) {
      doneAlarms.add(fromMap(map));
    }
    return doneAlarms;
  }

  @override
  DoneAlarm fromMap(Map<String, dynamic> query) {
    DoneAlarm doneAlarm = DoneAlarm();
    doneAlarm.id = query["id"];
    doneAlarm.habitId = query["habitId"];
    doneAlarm.creationDate =
        DateTime.fromMillisecondsSinceEpoch(query["creationDate"]);
    int isScaned = query["isScanned"];
    doneAlarm.isScanned = isScaned.toBool();
    doneAlarm.reason = query["reason"];
    return doneAlarm;
  }

  @override
  Map<String, dynamic> toMap(DoneAlarm object) {
    object.creationDate = DateTime.now();
    if (object.reason == null) {
      object.reason = "null";
    }
    return <String, dynamic>{
      columnId: object.id,
      columnHabitId: object.habitId,
      _columnCreationDate: object.creationDate.millisecondsSinceEpoch,
      _columnIsScanned: object.isScanned.toInt(),
      _columnReason: object.reason,
    };
  }
}
