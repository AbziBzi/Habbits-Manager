import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habbits_manager/view/goal_feature/goal_grid_list.dart';

void printHello() {
  // FlutterRingtonePlayer.play(
  //   android: AndroidSounds.alarm,
  //   ios: const IosSound(1023),
  //   looping: true,
  //   volume: 0.1,
  //   asAlarm: true,
  // );
}

void main() async {
  runApp(MyApp());
//   final int helloAlarmID = 0;
//   await AndroidAlarmManager.initialize();
//   await AndroidAlarmManager.periodic(
//       const Duration(seconds: 20), helloAlarmID, printHello);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF481550),
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.balooThambiTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/goallist',
      routes: {
        '/goallist': (context) => GoalList(),
      },
    );
  }
}
