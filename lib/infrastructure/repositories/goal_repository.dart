import 'package:habbits_manager/infrastructure/daos/goal_dao.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_goal_repository.dart';

class GoalDatabaseRepository implements GoalRepository {
  final dao = GoalDao();

  @override
  DatabaseProvider databaseProvider;

  GoalDatabaseRepository(this.databaseProvider);

  @override
  Future<Goal> getGoalById(int id) async {
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
  Future<List<Goal>> getAllGoals() async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromMapToList(maps);
  }

  @override
  Future<int> insert(Goal goal) async {
    final db = await databaseProvider.db();
    var goalId = await db.insert(dao.tableName, dao.toMap(goal));
    return goalId;
  }

  @override
  Future<int> update(Goal goal) async {
    final db = await databaseProvider.db();
    var goalId = await db.update(dao.tableName, dao.toMap(goal),
        where: dao.columnId + " = ?", whereArgs: [goal.id]);
    return goalId;
  }

  @override
  Future<int> delete(int id) async {
    final db = await databaseProvider.db();
    var goalId = await db
        .delete(dao.tableName, where: dao.columnId + " = ?", whereArgs: [id]);
    return goalId;
  }
}
