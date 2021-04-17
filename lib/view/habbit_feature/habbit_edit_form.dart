import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/view/alarm_feature/alarm_create_form.dart';
import 'package:habbits_manager/view/alarm_feature/alarm_edit_form.dart';

class HabbitEditForm extends StatefulWidget {
  final Habbit habbit;
  final Function(Habbit habbit, BuildContext context) onEditHabbit;

  HabbitEditForm(this.habbit, this.onEditHabbit);
  @override
  _HabbitEditFormState createState() => _HabbitEditFormState();
}

class _HabbitEditFormState extends State<HabbitEditForm> {
  final _formKey = GlobalKey<FormState>();

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
                      initialValue: widget.habbit.name,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.1),
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
                          setState(() => widget.habbit.name = value),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.40),
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      initialValue: widget.habbit.description,
                      maxLines: 3,
                      minLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(height: 0.1),
                        border: InputBorder.none,
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
                          setState(() => widget.habbit.description = value),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.6),
                  child: AlarmEditForm(widget.habbit.alarm, _onEditHabbitAlarm),
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
              _onEditHabbit(_formKey.currentState.validate(), context);
            },
            child: Text(
              'Save changes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  _onEditHabbitAlarm(Alarm alarm) {
    setState(() {
      widget.habbit.alarm = alarm;
    });
  }

  _onEditHabbit(bool isValid, BuildContext context) {
    if (isValid) {
      _formKey.currentState.save();
      Navigator.pop(context);
      widget.onEditHabbit(widget.habbit, context);
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error updating habbit.",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
