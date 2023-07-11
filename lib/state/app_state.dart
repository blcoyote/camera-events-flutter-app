import 'package:camera_events/models/event.model.dart';
import 'package:camera_events/services/notifications.dart';
import 'package:camera_events/services/user_api.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/token.model.dart';

class AppState extends ChangeNotifier {
  // Basic state for the app
  String _token = '';
  bool loadingApp = true;
  bool loggingIn = false;

  late String id = '';
  late final FirebaseAnalytics analytics;
  late final FirebaseMessaging messaging;
  late String fcmToken;
  UserService userService = UserService();

  late NotificationSettings settings;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final notificationlist = <EventModel>[];

  String get token {
    if (_token.isNotEmpty && JwtDecoder.isExpired(_token)) {
      logout();
    }
    return _token;
  }

  set token(String value) {
    _token = value;
    notifyListeners();
  }

  AppState() {
    loadSettings();
    Notifications.initialize(flutterLocalNotificationsPlugin);
    messaging = FirebaseMessaging.instance;
    analytics = FirebaseAnalytics.instance;
    registerFirebaseNotifications();
  }

  void registerFirebaseNotifications() async {
    settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Parse the message received

      //_totalNotifications++;
      notifyListeners();
    });
  }

  getFcmToken() async {
    fcmToken = await messaging.getToken().then((value) => fcmToken = value!);
    await userService.registerFcmToken(fcmToken, token);
    //post request
    notifyListeners();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    //evaluate if jwt token is valid
    var token = prefs.getString('token') ?? '';
    if (token.isEmpty || JwtDecoder.isExpired(token)) {
      prefs.remove('token');
      token = '';
    }
    this.token = token;
    loadingApp = false;

    notifyListeners();
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    this.token = token;
    prefs.setString('token', token);

    notifyListeners();
  }

  Future<void> processLogin(
      BuildContext context, String username, String password) async {
    loggingIn = true;

    // do api check and if successful. set token and
    try {
      TokenModel token = await UserService().login(username, password);
      setToken(token.accessToken);
    
    } catch (e) {
      final error = e.toString();

      final snackBar = SnackBar(
        content: Text('Error logging in: $error'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // no action needed
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    loggingIn = false;
    getFcmToken();
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    token = '';

    notifyListeners();
  }

  Future<void> sendNotification(String title, String body) async {
    await Notifications.showNotification(
        flutterLocalNotificationsPlugin, title, body);

    notifyListeners();
  }
}
