import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:habbits_manager/utils/notificationsUtil.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class AlarmService {
  AlarmService._privateConstructor();
  static final AlarmService instance = AlarmService._privateConstructor();

  static Future<void> callback(int id) async {
    tz.initializeTimeZones();
    currentTimezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));
    var now = tz.TZDateTime.now(tz.local).add(Duration(seconds: 5));
    await singleNotification(
      localNotificationsPlugin,
      now,
      "Habbits Manager App",
      "Scan QR code for your habit!",
      id,
      id.toString(),
    );
  }
}
