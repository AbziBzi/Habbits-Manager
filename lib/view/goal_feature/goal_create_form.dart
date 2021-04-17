import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/goal.dart';

class GoalCreateForm extends StatefulWidget {
  final Function(Goal goal) onCreateNewGoal;

  GoalCreateForm({this.onCreateNewGoal});

  @override
  _GoalCreateFormState createState() => _GoalCreateFormState();
}

class _GoalCreateFormState extends State<GoalCreateForm> {
  final _formKey = GlobalKey<FormState>();
  Goal newGoal = Goal();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 350,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'New Gaol Name',
                  contentPadding: EdgeInsets.all(15.0),
                  hintStyle: TextStyle(color: Colors.grey[300]),
                ),
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Enter your goal name';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => newGoal.name = value),
              ),
              TextFormField(
                maxLines: 5,
                minLines: 1,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'New Goal Description',
                  contentPadding: EdgeInsets.all(15.0),
                  hintStyle: TextStyle(color: Colors.grey[300]),
                ),
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Enter your goal description';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => newGoal.description = value),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blue[300],
                    ),
                  ),
                  onPressed: () {
                    _createGoal(_formKey.currentState.validate(), context);
                  },
                  child: Text(
                    'Create',
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
  }

  _createGoal(bool isValid, BuildContext _context) {
    if (isValid) {
      _formKey.currentState.save();
      Navigator.pop(_context);
      widget.onCreateNewGoal(newGoal);
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
}
