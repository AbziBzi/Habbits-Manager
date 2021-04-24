import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/habbit_repository.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_create_form.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_list_item.dart';
import 'package:habbits_manager/view/my_app_bar.dart';
import 'package:habbits_manager/view/qr_code_feature/qr_code_get.dart';
import 'package:habbits_manager/services/notification_service.dart';

class HabbitsList extends StatefulWidget {
  final String goalName;
  final int goalId;

  HabbitsList({this.goalName, this.goalId});

  @override
  _HabbitsListState createState() => _HabbitsListState();
}

class _HabbitsListState extends State<HabbitsList> {
  List<Habbit> _habbits = [];
  HabbitRepository _habbitRepository;
  AlarmRepository _alarmRepository;

  @override
  void initState() {
    super.initState();
    _alarmRepository = AlarmDatabaseRepository(DatabaseProvider.get);
    _habbitRepository =
        HabbitDatabaseRepository(DatabaseProvider.get, _alarmRepository);
    _refreshHabbitsList();
  }

  @override
  Widget build(BuildContext context) {
    void _showHabbitCreateForm() {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top:
                new Radius.elliptical(MediaQuery.of(context).size.width, 120.0),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            expand: false,
            builder: (_, controller) {
              return HabbitCreateForm(_onCeateHabbit);
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: MyAppBar(
        title: widget.goalName,
        onAddFunction: _showHabbitCreateForm,
      ),
      body: _getBodySection(_habbits),
    );
  }

  _refreshHabbitsList() async {
    List<Habbit> fetchedHabbits =
        await _habbitRepository.getAllGoalHabbits(widget.goalId);
    setState(() {
      _habbits = fetchedHabbits;
    });
  }

  Widget _getBodySection(List<Habbit> habbits) {
    if (habbits == null) {
      return Center(
          child: Text(
        'No Habbits added',
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
      ));
    }

    return Container(
      child: ListView.builder(
        itemCount: habbits.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
            child: Card(
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    HabbitListItem(
                      habbit: habbits[i],
                      habbitRepository: _habbitRepository,
                      alarmRepository: _alarmRepository,
                      refreshHabbitsList: _refreshHabbitsList,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _onCeateHabbit(Habbit habbit) async {
    var newAlarmId = await _onCreateHabbitAlarm(habbit.alarm);
    habbit.alarmId = newAlarmId;
    habbit.goalId = widget.goalId;
    var res = await _habbitRepository.insert(habbit);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "New habbit have been created",
        duration: Duration(seconds: 3),
      )..show(context);
      habbit.id = res;
      await onCreateAndroidAlarm(habbit);
      _showQRCodeDownloadDialog(habbit);
      _refreshHabbitsList();
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

  Future<int> _onCreateHabbitAlarm(Alarm alarm) async {
    var res = await _alarmRepository.insert(alarm);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "New alarm have been created",
        duration: Duration(seconds: 3),
      )..show(context);
      Navigator.pop(context);
      return res;
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error creating new alarm.",
        duration: Duration(seconds: 3),
      )..show(context);
      return 0;
    }
  }

  Future<void> onCreateAndroidAlarm(Habbit habbit) async {
    await AndroidAlarmManager.oneShotAt(
        habbit.alarm.dateTime, habbit.id, AlarmService.callback,
        exact: true, wakeup: true, alarmClock: true, allowWhileIdle: true);
  }

  _showQRCodeDownloadDialog(Habbit habbit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRCodeDownload(habbit);
      },
    );
  }
}
