import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/domain/models/doneAlarm.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_doneAlarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/doneAlarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/habbit_repository.dart';
import 'package:barcode_scan/barcode_scan.dart';

class AlarmRing extends StatefulWidget {
  final int habbitId;

  AlarmRing({Key key, this.habbitId}) : super(key: key);

  @override
  _AlarmRingState createState() => _AlarmRingState();
}

class _AlarmRingState extends State<AlarmRing> {
  final _formKey = GlobalKey<FormState>();
  HabbitRepository _habbitRepository;
  AlarmRepository _alarmRepository;
  DoneAlarmRepository _doneAlarmRepository;
  Habbit habbit;
  String barcode = "";
  String reason;

  void initialiseDetails() async {
    Habbit getHabbit = await _habbitRepository.getHabbitById(widget.habbitId);
    if (getHabbit != null) {
      setState(() {
        habbit = getHabbit;
      });
    }
    startAudio();
  }

  void startAudio() async {
    FlutterRingtonePlayer.playAlarm(
      volume: 1,
      looping: true,
      asAlarm: true,
    );
  }

  void stopAudio() async {
    FlutterRingtonePlayer.stop();
  }

  @override
  void initState() {
    super.initState();
    _alarmRepository = AlarmDatabaseRepository(DatabaseProvider.get);
    _habbitRepository =
        HabbitDatabaseRepository(DatabaseProvider.get, _alarmRepository);
    _doneAlarmRepository = DoneAlarmDatabaseRepository(DatabaseProvider.get);
    initialiseDetails();
  }

  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Are you attempting to leave the alarm hanging?'),
              content: new Text('Please scan QR code before you leave'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('OK'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      turnOffAlarm();
                    },
                    label: const Text(
                      'Scan QR Code',
                      style: TextStyle(fontSize: 20),
                    ),
                    icon: const Icon(
                      Icons.center_focus_weak,
                      size: 50,
                    ),
                    backgroundColor: Colors.pink,
                  ),
                ),
                SizedBox(height: 300),
                ElevatedButton(
                  onPressed: () async {
                    await _showAbandonDialog();
                  },
                  child: Text(
                    'Abandon',
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void turnOffAlarm() async {
    await scan();
    var scanedBarcode = int.tryParse(barcode);

    if (scanedBarcode != null && scanedBarcode == widget.habbitId) {
      stopAudio();
      await _updateHabbitsDate();
      await _onCreateDoneAlarm(true);
      Navigator.popAndPushNamed(context, '/');
      onShowSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  onShowSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 350,
            child: Text(
              'You have successfully scanned the QR code!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Future scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode.rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 350,
            child: Text(
              'QR Code you have scanned is wrong. Please scan QR code once again.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  _updateHabbitsDate() async {
    Habbit habbit = await _habbitRepository.getHabbitById(widget.habbitId);
    if (habbit != null) {
      Alarm alarm = await _alarmRepository.getAlarmById(habbit.alarmId);
      if (alarm != null) {
        alarm.dateTime.add(Duration(days: 1));
        int res = await _alarmRepository.update(alarm);
        if (res == null || res < 1) {
          print('error in _updateHabbitsDate');
        }
      }
    }
  }

  _onCreateDoneAlarm(bool isScanned) async {
    DoneAlarm doneAlarm = DoneAlarm(
      habitId: widget.habbitId,
      isScanned: isScanned,
      reason: reason,
    );

    var res = await _doneAlarmRepository.insert(doneAlarm);
    if (res > 0) {
      print('DoneAlarm created. Id: $res');
    } else {
      print('Could not create doneAlarm');
    }
  }

  _showAbandonDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 350,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'What is the reason of abandoning this alarm?',
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Reason',
                      contentPadding: EdgeInsets.all(15.0),
                      hintStyle: TextStyle(color: Colors.grey[300]),
                    ),
                    validator: (value) {
                      if (value.isEmpty || value == null) {
                        return 'Enter your reason';
                      }
                      return null;
                    },
                    onSaved: (value) => setState(() => reason = value),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue[300],
                        ),
                      ),
                      onPressed: () async {
                        _abandonAlarm();
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _abandonAlarm() async {
    _formKey.currentState.save();
    await _onCreateDoneAlarm(false);
    stopAudio();
    Navigator.popAndPushNamed(context, '/');
  }
}
