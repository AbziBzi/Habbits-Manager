import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:habbits_manager/domain/models/alarm.dart';
import 'package:habbits_manager/domain/models/habbit.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_alarm_repository.dart';
import 'package:habbits_manager/infrastructure/repositories/abstract_habbit_repository.dart';
import 'package:habbits_manager/services/notification_service.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_delete_dialog.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_details.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_edit_form.dart';

class HabbitListItem extends StatelessWidget {
  final Function() refreshHabbitsList;
  final HabbitRepository habbitRepository;
  final AlarmRepository alarmRepository;
  final Habbit habbit;

  HabbitListItem(
      {this.habbit,
      this.habbitRepository,
      this.alarmRepository,
      this.refreshHabbitsList});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              habbit.name,
              maxLines: 1,
            ),
          ),
          PopupMenuButton(
            onSelected: (result) {
              if (result == 1) {
                _onShowEditDialog(habbit, context);
              }
              if (result == 2) {
                _onShowDeleteDialog(habbit, context);
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
      onTap: () {
        _showHabbitDetails(context, habbit);
      },
    );
  }

  void _onShowEditDialog(Habbit habbit, BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: new Radius.elliptical(MediaQuery.of(context).size.width, 120.0),
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
            return HabbitEditForm(habbit, _onEditHabbit);
          },
        );
      },
    );
  }

  void _onShowDeleteDialog(Habbit habbit, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HabbitDelete(
          habbit,
          _onDeleteHabbit,
        );
      },
    );
  }

  void _onDeleteHabbit(int id, BuildContext context) async {
    var res = await habbitRepository.delete(id);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "Habbit have been deleted.",
        duration: Duration(seconds: 3),
      )..show(context);
      await _onCancelAndroidAlarm(id);
      refreshHabbitsList();
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error deleting habbit.",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  void _onEditHabbit(Habbit habbit, BuildContext context) async {
    await _onEditHabbitAlarm(habbit.alarm, context);
    var res = await habbitRepository.update(habbit);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "Habbit have been updated",
        duration: Duration(seconds: 3),
      )..show(context);
      await _onCancelAndroidAlarm(habbit.id);
      await _onCreateAndroidAlarm(habbit);
      refreshHabbitsList();
    } else {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "There was an error updating habbit.",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  _onEditHabbitAlarm(Alarm alarm, BuildContext context) async {
    var res = await alarmRepository.update(alarm);
    if (res > 0) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: "Alarm have been updated",
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
        message: "There was an error updating an alarm.",
        duration: Duration(seconds: 3),
      )..show(context);
      return 0;
    }
  }

  _showHabbitDetails(BuildContext context, Habbit habbit) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: new Radius.elliptical(MediaQuery.of(context).size.width, 120.0),
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
            return HabbitDetails(habbit);
          },
        );
      },
    );
  }

  Future<void> _onCancelAndroidAlarm(int id) async {
    await AndroidAlarmManager.cancel(id);
  }

  Future<void> _onCreateAndroidAlarm(Habbit habbit) async {
    await AndroidAlarmManager.oneShotAt(
        habbit.alarm.dateTime, habbit.id, AlarmService.callback,
        exact: true, wakeup: true, alarmClock: true, allowWhileIdle: true);
  }
}
