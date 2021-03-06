import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/goal.dart';

class GoalDelete extends StatelessWidget {
  final Goal goal;
  final Function(int goalId, BuildContext context) _onDeleteGoal;

  GoalDelete(this.goal, this._onDeleteGoal);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Text(
                'Are you sure you want to delete "${goal.name}" goal? All habbits and your progress will be deleted.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue[300],
                  ),
                ),
                onPressed: () {
                  _onDeleteGoal(goal.id, context);
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blue[300],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
