import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:intl/intl.dart';

class AlarmCreateForm extends StatefulWidget {
  final Function(Alarm alarm) _onCreateHabbitAlarm;

  AlarmCreateForm(this._onCreateHabbitAlarm);

  @override
  _AlarmCreateFormState createState() => _AlarmCreateFormState();
}

class _AlarmCreateFormState extends State<AlarmCreateForm> {
  TimeOfDay _time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      height: 100,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: _buildDailyTab(),
      ),
    );
  }

  Widget _buildDailyTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Starts on',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              InkWell(
                onTap: () {
                  _selectTime();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          _getTimeHours(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          _getTimeMinutes(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeMinutes() {
    String formattedDate = _getTimeInString();
    return formattedDate.split(':').last;
  }

  String _getTimeHours() {
    String formattedDate = _getTimeInString();
    return formattedDate.split(':').first;
  }

  String _getTimeInString() {
    final DateTime newDate = new DateTime(0, 0, 0, _time.hour, _time.minute);
    final DateFormat formatter = DateFormat('HH:mm');
    final String formatedTime = formatter.format(newDate);
    return formatedTime;
  }

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
      _onCreateAlarm();
    }
  }

  _onCreateAlarm() async {
    print('onCreateAlarm');
    DateTime now = DateTime.now();
    DateTime date =
        DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
    Alarm newAlarm = Alarm(dateTime: date, isActive: true);
    widget._onCreateHabbitAlarm(newAlarm);
  }
}
