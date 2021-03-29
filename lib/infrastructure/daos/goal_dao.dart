import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/infrastructure/daos/abstract_dao.dart';

class GoalDao implements Dao<Goal> {
  final tableName = 'goals';
  final columnId = 'id';
  final _columnName = 'name';
  final _columnDescription = 'description';
  final _columnCreationDate = 'creationDate';

  @override
  String get createTableQuery => "CREATE TABLE $tableName ("
      " $columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      " $_columnName TEXT NOT NULL,"
      " $_columnDescription TEXT,"
      " $_columnCreationDate INTEGER NOT NULL"
      ")";

  @override
  List<Goal> fromMapToList(List<Map<String, dynamic>> query) {
    List<Goal> goals = [];
    for (Map map in query) {
      goals.add(fromMap(map));
    }
    return goals;
  }

  @override
  Goal fromMap(Map<String, dynamic> query) {
    Goal goal = new Goal();
    goal.id = query['id'];
    goal.name = query['name'];
    goal.description = query['description'];
    goal.creationDate =
        DateTime.fromMillisecondsSinceEpoch(query['creationDate']);
    return goal;
  }

  @override
  Map<String, dynamic> toMap(Goal object) {
    return <String, dynamic>{
      columnId: object.id,
      _columnName: object.name,
      _columnDescription: object.description,
      _columnCreationDate: object.creationDate.millisecondsSinceEpoch,
    };
  }
}
