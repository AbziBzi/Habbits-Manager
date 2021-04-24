import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habbits_manager/utils/notificationsUtil.dart';
import 'package:habbits_manager/view/alarm_feature/alarm_ring.dart';
import 'package:habbits_manager/view/goal_feature/goal_grid_list.dart';
import 'package:habbits_manager/view/habbit_feature/habbit_list.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'homePage.dart';

FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future onSelectNotification(String payload) async {
  await Navigator.push(
    MyApp.navigatorKey.currentState.context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          AlarmRing(habbitId: int.parse(payload)),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await AndroidAlarmManager.initialize();
  await initializeNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF481550),
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.balooThambiTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomePage(),
      initialRoute: '/',
      routes: {
        '/goallist': (context) => GoalList(),
        '/alarmring': (context) => AlarmRing(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
