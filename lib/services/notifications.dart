import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }


  static Future showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title,
      String body) async {
    var androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('camera_events', 'Camera events',
            channelDescription: 'Camera event notifications',
            playSound: true,
            //sound: RawResourceAndroidNotificationSound('notification'),
            importance: Importance.max,
            priority: Priority.high);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }
}
