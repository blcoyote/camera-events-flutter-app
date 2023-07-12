import 'dart:developer';
import 'dart:typed_data';

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
import '../services/event_api.dart';

class AppState extends ChangeNotifier {
  // Basic state for the app
  String _token = '';
  String username = '';
  String refreshToken = '';
  bool loadingApp = true;
  bool loggingIn = false;

  late String id = '';
  late final FirebaseAnalytics analytics;
  late final FirebaseMessaging messaging;
  late String fcmToken;
  UserService userService = UserService();


  bool isEventsLoading = false;
  bool isEventsError = false;
  String eventsErrorMessage = '';
  List<EventModel> events = <EventModel>[];
  bool isEventDetailImageLoading = false;
  bool hasEventsLoaded = false;
  EventService eventService = EventService();

  late NotificationSettings settings;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final notificationlist = <EventModel>[];

  String get token {
    if (_token.isNotEmpty && JwtDecoder.isExpired(_token)) {
      _token = '';
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
    refreshToken = prefs.getString('refreshToken') ?? '';
    username = prefs.getString('username') ?? '';
    if (token.isEmpty || JwtDecoder.isExpired(token)) {
      prefs.remove('token');
      token = '';
    }
    this.token = token;

    if (token.isEmpty || refreshToken.isNotEmpty) {
      await processSilentLogin(username, refreshToken);
    }
    loadingApp = false;

    notifyListeners();
  }

  Future<void> setToken(String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    this.token = token;
    this.refreshToken = refreshToken;
    prefs.setString('token', token);
    prefs.setString('refreshToken', refreshToken);

    notifyListeners();
  }

  Future<void> processLogin(
      BuildContext context, String username, String password) async {
    loggingIn = true;
    
    // do api check and if successful. set token and
    try {
      final prefs = await SharedPreferences.getInstance();
      TokenModel token = await UserService().login(username, password);
      setToken(token.accessToken, token.refreshToken);
      username = username;
      prefs.setString('username', username);
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

  Future<void> processSilentLogin(String username, String refreshToken) async {
    try {
      TokenModel token = await UserService().refresh(username, refreshToken);
      setToken(token.accessToken, token.refreshToken);
    } catch (e) {
      await logout();
    }

    loggingIn = false;
    getFcmToken();
    notifyListeners();
  }

  Future<void> logout() async {
    setToken('', '');
    notifyListeners();
  }

  Future<void> sendNotification(String title, String body) async {
    await Notifications.showNotification(
        flutterLocalNotificationsPlugin, title, body);
    notifyListeners();
  }

  Future<void> getEvents({bool forceRefresh = false}) async {
    if (forceRefresh || !hasEventsLoaded) {
      isEventsLoading = true;
      try {
        var eventsRequest = await eventService.getEvents(token);
        if (eventsRequest == null) {
          throw Exception(eventsErrorMessage);
        }
        events = eventsRequest;
      } catch (e) {
        isEventsError = true;
        eventsErrorMessage = e.toString();
      } finally {
        isEventsLoading = false;
        hasEventsLoaded = true;

        notifyListeners();
      }
    }
  }

  Future<Uint8List> getSnapshot(String eventId) async {
    isEventDetailImageLoading = true;
    try {
      var image = await EventService().getSnapshot(token, eventId);
      return image;
    } catch (e) {
      log(e.toString());
    } finally {
      isEventDetailImageLoading = false;
    }
    throw Exception('Failed to load snapshot');
  }
}
