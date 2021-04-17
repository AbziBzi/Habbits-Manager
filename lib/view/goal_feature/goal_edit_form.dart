import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/goal.dart';

class GoalEditForm extends StatefulWidget {
  final Goal goal;
  final Function(Goal goal, BuildContext context) onEditGoal;

  GoalEditForm({this.onEditGoal, this.goal});

  @override
  _GoalEditFormState createState() => _GoalEditFormState();
}

class _GoalEditFormState extends State<GoalEditForm> {
  final _formKey = GlobalKey<FormState>();

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
                initialValue: widget.goal.name,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                ),
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Enter your goal name';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => widget.goal.name = value),
              ),
              TextFormField(
                initialValue: widget.goal.description,
                maxLines: 5,
                minLines: 1,
                style: TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                ),
                validator: (value) {
                  if (value.isEmpty || value == null) {
                    return 'Enter your goal description';
                  }
                  return null;
                },
                onSaved: (value) =>
                    setState(() => widget.goal.description = value),
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
                    _updateGoal(_formKey.currentState.validate(), context);
                  },
                  child: Text(
                    'Save changes',
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

  _updateGoal(bool isValid, BuildContext _context) {
    if (isValid) {
      _formKey.currentState.save();
      Navigator.pop(_context);
      widget.onEditGoal(widget.goal, _context);
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
}
