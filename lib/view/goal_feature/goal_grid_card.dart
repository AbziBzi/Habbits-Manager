import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_goal_repository.dart';
import 'package:habbits_manager/view/goal_feature/goal_delete_dialog.dart';
import 'package:habbits_manager/view/goal_feature/goal_edit_form.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_list.dart';

class GoalCard extends StatelessWidget {
  final Function() refreshGoalList;
  final Goal goal;
  final GoalRepository repository;

  GoalCard(this.goal, this.refreshGoalList, this.repository);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkResponse(
          onTap: () => _onNavigateToHabbitsList(context),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      goal.name,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    onSelected: (result) {
                      if (result == 1) {
                        _onGoalShowEditDialog(goal, context);
                      }
                      if (result == 2) {
                        _onShowDeleteDialog(goal, context);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: 1,
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                goal.description,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _getHabbitsCountString(goal.habbits).toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNavigateToHabbitsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HabbitsList(
          // habbits: [
          //   Habbit(
          //     id: 1,
          //     name: 'Wake up early',
          //     description:
          //         'I want to wake up early. Early for me is 7 o\'clock',
          //     creationDate: DateTime.now().toUtc(),
          //     alarmId: 1,
          //     alarm: Alarm(
          //       alarmType: AlarmType.daily,
          //       id: 1,
          //       dateTime: DateTime.now(),
          //     ),
          //   ),
          //   Habbit(
          //     id: 1,
          //     name: 'asdasda up early',
          //     description:
          //         'I asdasdasdas to wake up early. Early for me is 7 o\'clock',
          //     creationDate: DateTime.now().toUtc(),
          //     alarmId: 1,
          //     alarm: Alarm(
          //       alarmType: AlarmType.daily,
          //       id: 1,
          //       dateTime: DateTime(2021, 04, 11, 12, 23, 23),
          //     ),
          //   ),
          //   Habbit(
          //     id: 1,
          //     name: 'asdasda up early2',
          //     description:
          //         'I asdasdasdas to wake up early. Early for me is 7 o\'clock',
          //     creationDate: DateTime.now().toUtc(),
          //     alarmId: 1,
          //     alarm: Alarm(
          //       alarmType: AlarmType.daily,
          //       id: 1,
          //       dateTime: DateTime(2021, 04, 12, 12, 23, 23),
          //     ),
          //   ),
          //   Habbit(
          //     id: 1,
          //     name: 'DateTime(2021, 04, 12, 12, 23, 23)',
          //     description:
          //         'I asdasdasdas to wake up early. Early for me is 7 o\'clock',
          //     creationDate: DateTime.now().toUtc(),
          //     alarmId: 1,
          //     alarm: Alarm(
          //       alarmType: AlarmType.daily,
          //       id: 1,
          //       dateTime: DateTime(2021, 05, 12, 12, 23, 23),
          //     ),
          //   ),
          // ],
          goalName: goal.name,
          goalId: goal.id,
        ),
      ),
    );
  }

  void _onGoalShowEditDialog(Goal goal, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GoalEditForm(
          onEditGoal: _onEditGoal,
          goal: goal,
        );
      },
    );
  }

  void _onShowDeleteDialog(Goal goal, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GoalDelete(
          goal,
          _onDeleteGoal,
        );
      },
    );
  }

  void _onDeleteGoal(int id, BuildContext context) async {
    var res = await repository.delete(id);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "Goal have been deleted.",
        duration: Duration(seconds: 3),
      )..show(context);
      refreshGoalList();
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error deleting goal.",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  void _onEditGoal(Goal goal, BuildContext context) async {
    var res = await repository.update(goal);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "Goal have been updated",
        duration: Duration(seconds: 3),
      )..show(context);
      refreshGoalList();
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error updating goal.",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  String _getHabbitsCountString(List<Habbit> habbits) {
    if (habbits == null || habbits.isEmpty) {
      return 'no habbits';
    } else {
      var lengthString = habbits.length.toString();
      if (habbits.length == 1) {
        return lengthString + ' habbit';
      } else {
        return lengthString + ' habbits';
      }
    }
  }
}
