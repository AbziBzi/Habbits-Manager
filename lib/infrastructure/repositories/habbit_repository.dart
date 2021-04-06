import 'package:habbits_manager/infrastructure/daos/habbit_dao.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';

class HabbitDatabaseRepository implements HabbitRepository {
  final dao = HabbitDao();

  @override
  DatabaseProvider databaseProvider;

  HabbitDatabaseRepository(this.databaseProvider);

  @override
  Future<Habbit> getHabbitById(int id) async {
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
  Future<List<Habbit>> getAllHabbits() async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromMapToList(maps);
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
}
