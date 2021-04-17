import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/infrastructure/database/database_provider.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_goal_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/goal_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/habbit_repository.dart';
import 'package:habbits_manager/view/goal_feature/goal_create_form.dart';
import 'package:habbits_manager/view/goal_feature/goal_grid_card.dart';
import 'package:habbits_manager/view/my_app_bar.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  List<Goal> _goals = [];
  GoalRepository _goalRepository;
  HabbitRepository _habbitRepository;
  AlarmRepository _alarmRepository;

  @override
  void initState() {
    super.initState();
    _goalRepository = GoalDatabaseRepository(DatabaseProvider.get);
    _alarmRepository = AlarmDatabaseRepository(DatabaseProvider.get);
    _habbitRepository =
        HabbitDatabaseRepository(DatabaseProvider.get, _alarmRepository);
    _refreshGoalsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'My Goals',
        onAddFunction: _showGoalCreateForm,
      ),
      body: _getGoalsGrid(_goals),
    );
  }

  _refreshGoalsList() async {
    List<Goal> fetchedGoals = await _goalRepository.getAllGoals();
    setState(() {
      _goals = fetchedGoals;
    });
  }

  _onCeateGoal(Goal goal) async {
    var res = await _goalRepository.insert(goal);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "New goal have been created",
        duration: Duration(seconds: 3),
      )..show(context);
      _refreshGoalsList();
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error creating new goal.",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  void _showGoalCreateForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GoalCreateForm(
          onCreateNewGoal: _onCeateGoal,
        );
      },
    );
  }

  Widget _getGoalsGrid(List<Goal> goals) {
    return GridView.builder(
      primary: false,
      padding: const EdgeInsets.all(10),
      itemCount: goals.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return GoalCard(goals[index], _refreshGoalsList, _goalRepository,
            _habbitRepository);
      },
    );
  }
}
