import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/view/alarm_feature/alarm_create_form.dart';

class HabbitCreateForm extends StatefulWidget {
  final Function(Habbit habbit) onCreateHabbit;

  HabbitCreateForm(this.onCreateHabbit);

  @override
  _HabbitCreateFormState createState() => _HabbitCreateFormState();
}

class _HabbitCreateFormState extends State<HabbitCreateForm> {
  final _formKey = GlobalKey<FormState>();
  Habbit newHabbit = Habbit();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          const Color(0xFFfdb561),
                          const Color(0xFF481550),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(
                            MediaQuery.of(context).size.width, 120.0),
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 120.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.8),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.1),
                        hintText: 'New Habbit Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0),
                        hintStyle: TextStyle(color: Colors.grey[300]),
                      ),
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Enter your habbit name';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          setState(() => newHabbit.name = value),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.40),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      maxLines: 3,
                      minLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.1),
                        border: InputBorder.none,
                        hintText: 'New Habbit Description',
                        contentPadding: EdgeInsets.all(15.0),
                        hintStyle: TextStyle(color: Colors.grey[300]),
                      ),
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Enter your habbit description';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          setState(() => newHabbit.description = value),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.6),
                  child: AlarmCreateForm(_onCreateHabbitAlarm),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 160.0, 40.0, 0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color(0xFFfdb561),
              ),
            ),
            onPressed: () {
              _createHabbit(_formKey.currentState.validate(), context);
            },
            child: Text(
              'Create',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  _onCreateHabbitAlarm(Alarm alarm) async {
    setState(() {
      newHabbit.alarm = alarm;
    });
  }

  _createHabbit(bool isValid, BuildContext _context) async {
    if (isValid) {
      if (newHabbit.alarm == null) {
        _showNullAlarmDialog();
        return;
      }
      _formKey.currentState.save();
      Navigator.pop(_context);
      widget.onCreateHabbit(newHabbit);
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error creating new habbit.",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  _showNullAlarmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'It seems, that you have not created an Alarm',
              ),
            ],
          ),
        );
      },
    );
  }
}
