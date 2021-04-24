import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/doneAlarm.dart';
import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/habbit_repository.dart';

class GoalStats extends StatefulWidget {
  final Goal goal;
  final List<DoneAlarm> doneAlarms;

  GoalStats({this.goal, this.doneAlarms});

  @override
  _GoalStatsState createState() => _GoalStatsState();
}

class _GoalStatsState extends State<GoalStats> {
  AlarmRepository _alarmRepository;
  HabbitRepository _habbitRepository;
  List<Habbit> goalHabits;
  double scannedCount;
  double notScannedCount;
  double value;
  bool isEmpty = false;
  bool isLoaded = false;
  int goalDoneAlarms;

  @override
  void initState() {
    super.initState();
    _alarmRepository = AlarmDatabaseRepository(DatabaseProvider.get);
    _habbitRepository =
        HabbitDatabaseRepository(DatabaseProvider.get, _alarmRepository);

    _onInitializeData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Text("Loading"),
            ],
          ),
        ),
      );
    } else if (isEmpty) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
        child: Card(
          child: ExpansionTile(
            title: Text(
              widget.goal.name,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            children: <Widget>[
              ListTile(
                title: Column(
                  children: [
                    LinearProgressIndicator(
                      minHeight: 10,
                      backgroundColor: Color(0xfff8b250),
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xff0293ee)),
                      value: value,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${scannedCount.toInt()}'),
                        Text('${notScannedCount.toInt()}')
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  _onInitializeData() async {
    await _onFetchAllGoalHabbits(widget.goal.id);
    _onGetScannedCounts();
    _getIndicatorValue();
    setState(() {
      isLoaded = true;
    });
  }

  _onFetchAllGoalHabbits(int goalId) async {
    List<Habbit> goalHabits = await _habbitRepository.getAllGoalHabbits(goalId);

    setState(() {
      this.goalHabits = goalHabits;
    });
  }

  _onGetScannedCounts() {
    double scanned = 0;
    double notScanned = 0;
    int goalDoneAlarms = 0;

    if (goalHabits == null || goalHabits.isEmpty) {
      setState(() {
        this.isEmpty = true;
      });
    } else {
      for (var habbit in goalHabits) {
        for (var doneAlarm in widget.doneAlarms) {
          if (doneAlarm.habitId == habbit.id) {
            goalDoneAlarms += 1;
            if (doneAlarm.isScanned) {
              scanned += 1;
            } else {
              notScanned += 1;
            }
          }
        }
      }
    }
    setState(() {
      scannedCount = scanned;
      notScannedCount = notScanned;
      this.goalDoneAlarms = goalDoneAlarms;
    });
  }

  _getIndicatorValue() {
    value = (scannedCount / goalDoneAlarms);
    setState(() {
      this.value = value;
    });
  }
}
