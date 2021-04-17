import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:intl/intl.dart';

class AlarmEditForm extends StatefulWidget {
  final Alarm alarm;
  final Function(Alarm alarm) _onEditHabbitAlarm;

  AlarmEditForm(this.alarm, this._onEditHabbitAlarm);

  @override
  _AlarmEditFormState createState() => _AlarmEditFormState();
}

class _AlarmEditFormState extends State<AlarmEditForm> {
  TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = TimeOfDay(
        hour: widget.alarm.dateTime.hour, minute: widget.alarm.dateTime.minute);
  }

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
      initialTime: TimeOfDay(hour: 07, minute: 00),
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
      _onEditAlarm();
    }
  }

  _onEditAlarm() {
    DateTime newTime = DateTime(
        widget.alarm.dateTime.year,
        widget.alarm.dateTime.month,
        widget.alarm.dateTime.day,
        _time.hour,
        _time.minute);
    setState(() {
      widget.alarm.dateTime = newTime;
    });
    widget._onEditHabbitAlarm(widget.alarm);
  }
}
