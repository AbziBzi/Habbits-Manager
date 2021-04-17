import 'package:another_flushbar/flushbar.dart';
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

class HabbitsList extends StatefulWidget {
  final String goalName;
  final int goalId;

  HabbitsList({this.goalName, this.goalId});

  @override
  _HabbitsListState createState() => _HabbitsListState();
}

class _HabbitsListState extends State<HabbitsList> {
  final List<String> timePeriods = [
    'Today',
    'Tomorrow',
    'Later This Week',
    'Others'
  ];
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
      body: _getBodySection(timePeriods, _habbits),
    );
  }

  _refreshHabbitsList() async {
    List<Habbit> fetchedHabbits =
        await _habbitRepository.getAllGoalHabbits(widget.goalId);
    setState(() {
      _habbits = fetchedHabbits;
    });
  }

  Widget _getBodySection(List<String> timePeriods, List<Habbit> habbits) {
    return Container(
      child: ListView.separated(
        itemCount: timePeriods.length,
        itemBuilder: (context, i) {
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                timePeriods[i].toUpperCase(),
                style: TextStyle(
                  color: Colors.blue[300],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: <Widget>[
                Column(
                  children: _getHabbits(_habbits, context, timePeriods[i]),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  List<Widget> _getHabbits(
      List<Habbit> habbits, BuildContext context, String timePeriod) {
    List<Widget> columnContent = [];

    if (habbits != null) {
      for (Habbit habbit in habbits) {
        if (habbit.alarm != null) {
          switch (timePeriod) {
            case "Today":
              int daysDiffrence = 0;
              if (habbitInPeriod(daysDiffrence, habbit.alarm.dateTime))
                columnContent.add(HabbitListItem(habbit, _habbitRepository,
                    _alarmRepository, _refreshHabbitsList));
              break;
            case "Tomorrow":
              int daysDiffrence = 1;
              if (habbitInPeriod(daysDiffrence, habbit.alarm.dateTime))
                columnContent.add(HabbitListItem(habbit, _habbitRepository,
                    _alarmRepository, _refreshHabbitsList));
              break;
            case "Later This Week":
              if (_laterThisWeek(habbit.alarm.dateTime))
                columnContent.add(HabbitListItem(habbit, _habbitRepository,
                    _alarmRepository, _refreshHabbitsList));
              break;
            case "Others":
              if (!_laterThisWeek(habbit.alarm.dateTime) &&
                  dateDiffrence(habbit.alarm.dateTime) > 1)
                columnContent.add(HabbitListItem(habbit, _habbitRepository,
                    _alarmRepository, _refreshHabbitsList));
              break;
            default:
          }
        } else if (timePeriod == "Others") {
          columnContent.add(HabbitListItem(habbit, _habbitRepository,
              _alarmRepository, _refreshHabbitsList));
        }
      }
    }
    return columnContent;
  }

  bool _laterThisWeek(DateTime alarmDateTime) {
    DateTime currentTime = DateTime.now();
    if (dateDiffrence(alarmDateTime) < 7 &&
        dateDiffrence(alarmDateTime) > 1 &&
        (currentTime.weekday - alarmDateTime.weekday) <
            (7 - currentTime.weekday)) {
      return true;
    }
    return false;
  }

  bool habbitInPeriod(int dayDiffrence, DateTime alarmDateTime) {
    if (dateDiffrence(alarmDateTime) == dayDiffrence) return true;
    return false;
  }

  int dateDiffrence(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
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

  _showQRCodeDownloadDialog(Habbit habbit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRCodeDownload(habbit);
      },
    );
  }
}
