import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/infrastructure/daos/abstract_dao.dart';
import 'package:habbits_manager/utils/string_extensions.dart';
import 'package:habbits_manager/utils/alarmType_extensions.dart';

class AlarmDao implements Dao<Alarm> {
  final tableName = 'alarms';
  final columnId = 'id';
  final _columnDateTime = 'dateTime';
  final _columnAlarmType = 'alarmType';

  @override
  String get createTableQuery => "CREATE TABLE $tableName("
      " $columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      " $_columnDateTime NTEGER NOT NULL,"
      " $_columnAlarmType TEXT CHECK( alarmType IN ('daily', 'weekly', 'monthly')) NOT NULL"
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
    alarm.alarmType = query["alarmType"].toString().toAlarmType();
    return alarm;
  }

  @override
  Map<String, dynamic> toMap(Alarm object) {
    return <String, dynamic>{
      columnId: object.id,
      _columnDateTime: object.dateTime.millisecondsSinceEpoch,
      _columnAlarmType: object.alarmType.toShortString()
    };
  }
}
