import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/daos/abstract_dao.dart';
import 'package:habbits_manager/infrastructure/daos/alarm_dao.dart';

class HabbitDao implements Dao<Habbit> {
  final tableName = 'habbits';
  final columnId = 'id';
  final _columnName = 'name';
  final _columnDescription = 'description';
  final _columnCreationDate = 'creationDate';
  final columnGoalId = 'goalId';
  final _columnAlarmId = 'alarmId';
  final _columnGoal = 'goal';
  final _columnAlarm = 'alarm';

  @override
  String get createTableQuery => "CREATE TABLE $tableName ("
      " $columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      " $_columnName TEXT NOT NULL,"
      " $_columnDescription TEXT,"
      " $_columnCreationDate INTEGER NOT NULL,"
      " $columnGoalId INTEGER NOT NULL,"
      " $_columnAlarmId INTEGER NOT NULL,"
      " FOREIGN KEY ($columnGoalId) REFERENCES $_columnGoal ($columnId),"
      " FOREIGN KEY ($_columnAlarmId) REFERENCES $_columnAlarm ($columnId)"
      ")";

  @override
  List<Habbit> fromMapToList(List<Map<String, dynamic>> query) {
    List<Habbit> habbits = [];
    for (Map map in query) {
      habbits.add(fromMap(map));
    }
    return habbits;
  }

  @override
  Habbit fromMap(Map<String, dynamic> query) {
    Habbit habbit = new Habbit();
    habbit.id = query['id'];
    habbit.name = query['name'];
    habbit.description = query['description'];
    habbit.creationDate =
        DateTime.fromMillisecondsSinceEpoch(query['creationDate']);
    habbit.goalId = query['goalId'];
    habbit.alarmId = query['alarmId'];
    habbit.alarm =
        query['alarm'] != null ? new AlarmDao().fromMap(query['alarm']) : null;
    return habbit;
  }

  @override
  Map<String, dynamic> toMap(Habbit object) {
    object.creationDate = DateTime.now();
    return <String, dynamic>{
      columnId: object.id,
      _columnName: object.name,
      _columnDescription: object.description,
      _columnCreationDate: object.creationDate.millisecondsSinceEpoch,
      columnGoalId: object.goalId,
      _columnAlarmId: object.alarmId
    };
  }
}
