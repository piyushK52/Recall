import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializeSettings = AndroidInitializationSettings('app_notif_icon');

    initializationSettings = InitializationSettings(initializeSettings, null);
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  onNotificationClick(payload) {}

  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'RECALLS',
      'RECALL_NOTIF',
      'REVISION_NOTIF',
      importance: Importance.Max,
      priority: Priority.High,
    );

    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'Test', 'description', platformChannelSpecifics,
        payload: 'test payload');
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(
      Duration(seconds: 10),
    );
    var androidChannelSpecifics = AndroidNotificationDetails(
      'RECALLS',
      'RECALL_NOTIF',
      'REVISION_NOTIF',
      importance: Importance.Max,
      priority: Priority.High,
    );

    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Test',
      'description',
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      payload: 'test payload',
      androidAllowWhileIdle: true,
    );
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}
