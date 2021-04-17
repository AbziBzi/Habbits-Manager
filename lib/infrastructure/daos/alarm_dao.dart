import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/infrastructure/daos/abstract_dao.dart';
import 'package:habbits_manager/utils/int_bool_extensions.dart';

class AlarmDao implements Dao<Alarm> {
  final tableName = 'alarms';
  final columnId = 'id';
  final _columnDateTime = 'dateTime';
  final _columnIsActive = 'isActive';

  @override
  String get createTableQuery => "CREATE TABLE $tableName("
      " $columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      " $_columnDateTime INTEGER NOT NULL,"
      " $_columnIsActive INTAGER NOT NULL"
      ")";

  @override
  List<Alarm> fromMapToList(List<Map<String, dynamic>> query) {
    List<Alarm> alarms = [];
    for (Map map in query) {
      alarms.add(fromMap(map));
    }
    return alarms;
  }

  @override
  Alarm fromMap(Map<String, dynamic> query) {
    Alarm alarm = Alarm();
    alarm.id = query["id"];
    alarm.dateTime = DateTime.fromMillisecondsSinceEpoch(query["dateTime"]);
    int isActive = query["isActive"];
    alarm.isActive = isActive.toBool();
    return alarm;
  }

  @override
  Map<String, dynamic> toMap(Alarm object) {
    return <String, dynamic>{
      columnId: object.id,
      _columnDateTime: object.dateTime.millisecondsSinceEpoch,
      _columnIsActive: object.isActive.toInt(),
    };
  }
}
