import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';

abstract class GoalRepository {
  DatabaseProvider databaseProvider;

  Future<int> insert(Goal goal);
  Future<int> update(Goal goal);
  Future<int> delete(int id);
  Future<Goal> getGoalById(int id);
  Future<List<Goal>> getAllGoals();
}
