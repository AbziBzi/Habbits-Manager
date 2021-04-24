class DoneAlarm {
  int id;
  int habitId;
  DateTime creationDate;
  bool isScanned;
  String reason;

  DoneAlarm(
      {this.id, this.habitId, this.creationDate, this.isScanned, this.reason});
}
