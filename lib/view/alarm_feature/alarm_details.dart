import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:intl/intl.dart';

class AlarmDetails extends StatefulWidget {
  final Alarm alarm;

  AlarmDetails(this.alarm);

  @override
  _AlarmDetailsState createState() => _AlarmDetailsState();
}

class _AlarmDetailsState extends State<AlarmDetails> {
  bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.alarm.isActive;
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
        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getAlarmDate(),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAlarmDate() {
    String result = "Every";
    result += " day at " + _getDateToString('HH:mm');
    return result;
  }

  String _getDateToString(String formatt) {
    final DateFormat formatter = DateFormat(formatt);
    final String formatedTime = formatter.format(widget.alarm.dateTime);
    return formatedTime;
  }
}
