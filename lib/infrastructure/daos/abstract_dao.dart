abstract class Dao<T> {
  String get createTableQuery;

  T fromMap(Map<String, dynamic> query);
  List<T> fromMapToList(List<Map<String, dynamic>> query);
  Map<String, dynamic> toMap(T object);
}
