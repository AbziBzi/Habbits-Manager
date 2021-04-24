import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:habbits_manager/main.dart';
import 'package:rxdart/rxdart.dart';
import 'receivedNotification.dart';
import 'package:timezone/timezone.dart' as tz;

String currentTimezone = 'Unknown';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

initializeNotifications() async {
  var initialiseAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initialiseIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initSettings =
      InitializationSettings(android: initialiseAndroid, iOS: initialiseIOS);
  await localNotificationsPlugin.initialize(initSettings,
      onSelectNotification: onSelectNotification);

  currentTimezone = await FlutterNativeTimezone.getLocalTimezone();
}

Future singleNotification(
    FlutterLocalNotificationsPlugin localNotificationsPlugin,
    tz.TZDateTime datetime,
    String message,
    String subtext,
    int hashcode,
    String docId,
    {String sound}) async {
  var androidChannel = AndroidNotificationDetails(
    'channel-id',
    'channel-name',
    'channel-description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    additionalFlags: Int32List.fromList(<int>[4]),
    fullScreenIntent: true,
  );

  var platformChannel = NotificationDetails(android: androidChannel);
  localNotificationsPlugin.zonedSchedule(
    hashcode,
    message,
    subtext,
    datetime,
    platformChannel,
    payload: docId,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> cancelAlarm(int id) async {
  await localNotificationsPlugin.cancel(id);
}

void requestPermissions() {
  localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}
