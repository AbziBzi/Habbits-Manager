import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';

abstract class HabbitRepository {
  DatabaseProvider databaseProvider;

  Future<int> insert(Habbit habbit);
  Future<int> update(Habbit habbit);
  Future<int> delete(int id);
  Future<Habbit> getHabbitById(int id);
  Future<List<Habbit>> getAllHabbits();
}
