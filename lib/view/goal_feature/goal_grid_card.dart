import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/goal.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_goal_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';
import 'package:habbits_manager/view/goal_feature/goal_delete_dialog.dart';
import 'package:habbits_manager/view/goal_feature/goal_edit_form.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_list.dart';

class GoalCard extends StatefulWidget {
  final Function() refreshGoalList;
  final Goal goal;
  final GoalRepository _goalRepository;
  final HabbitRepository _habbitRepository;

  GoalCard(this.goal, this.refreshGoalList, this._goalRepository,
      this._habbitRepository);

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  int habbitsCount;

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
                      widget.goal.name,
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
                        _onGoalShowEditDialog(widget.goal, context);
                      }
                      if (result == 2) {
                        _onShowDeleteDialog(widget.goal, context);
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
                widget.goal.description,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _getHabbitsCountString().toUpperCase(),
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
          goalName: widget.goal.name,
          goalId: widget.goal.id,
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
    var res = await widget._goalRepository.delete(id);
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
      widget.refreshGoalList();
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
    var res = await widget._goalRepository.update(goal);
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
      widget.refreshGoalList();
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

  String _getHabbitsCountString() {
    _getHabbitsCount();
    if (habbitsCount == 0) {
      return 'no habbits';
    } else {
      var lengthString = habbitsCount.toString();
      if (habbitsCount == 1) {
        return lengthString + ' habbit';
      } else {
        return lengthString + ' habbits';
      }
    }
  }

  _getHabbitsCount() async {
    int habbitsCount =
        await widget._habbitRepository.getHabbitsCount(widget.goal.id);
    if (this.mounted) {
      setState(() {
        this.habbitsCount = habbitsCount;
      });
    }
  }
}
