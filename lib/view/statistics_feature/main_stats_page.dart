import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/doneAlarm.dart';
import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_doneAlarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_goal_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/doneAlarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/goal_repository.dart';
import 'package:habbits_manager/view/statistics_feature/goal_stats.dart';
import 'package:habbits_manager/view/statistics_feature/pie_chart.dart';

class MainStatsPage extends StatefulWidget {
  @override
  _MainStatsPageState createState() => _MainStatsPageState();
}

class _MainStatsPageState extends State<MainStatsPage> {
  List<DoneAlarm> doneAlarms;
  List<Goal> goals;
  DoneAlarmRepository _doneAlarmRepository;
  GoalRepository _goalRepository;
  int touchedIndex;
  double scannedCount;
  double notScannedCount;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _doneAlarmRepository = DoneAlarmDatabaseRepository(DatabaseProvider.get);
    _goalRepository = GoalDatabaseRepository(DatabaseProvider.get);
    _onInitializeData();
  }

  _onInitializeData() async {
    await _onFetchDoneAlarms();
    await _onFetchGoals();
    _onInitScannedCounts();

    setState(() {
      isLoaded = true;
    });
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
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'All Goals Statistics',
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  MyPieChart(
                    doneAlarms: doneAlarms,
                    scannedCount: scannedCount,
                    notScannedCount: notScannedCount,
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return buildRow(goals[index]);
                },
                childCount: goals.length,
              ),
            )
          ],
        ),
      );
    }
  }

  buildRow(Goal goal) {
    return GoalStats(goal: goal, doneAlarms: doneAlarms);
  }

  _onFetchDoneAlarms() async {
    List<DoneAlarm> doneAlarms = await _doneAlarmRepository.getAllDoneAlarms();
    setState(() {
      this.doneAlarms = doneAlarms;
    });
  }

  _onFetchGoals() async {
    List<Goal> goals = await _goalRepository.getAllGoals();
    setState(() {
      this.goals = goals;
    });
  }

  _onInitScannedCounts() {
    double scanned = 0;
    double notScanned = 0;

    for (var doneAlarm in doneAlarms) {
      if (doneAlarm.isScanned) {
        scanned += 1;
      } else {
        notScanned += 1;
      }
    }
    setState(() {
      scannedCount = scanned;
      notScannedCount = notScanned;
    });
  }
}
