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
import 'dart:developer';
import 'dart:typed_data';

class AppState extends ChangeNotifier {
  // login state
  String _token = '';
  String _username = '';
  String _refreshToken = '';
  bool loadingApp = true;
  bool loggingIn = false;

  // basic app state
  //late String id = '';
  late final FirebaseAnalytics analytics;
  late final FirebaseMessaging messaging;
  late String fcmToken;
  UserService userService = UserService();
  EventService eventService = EventService();
  late int eventsLimit;

  // events state
  bool isEventsLoading = false;
  bool isEventsError = false;
  String eventsErrorMessage = '';
  List<EventModel> events = <EventModel>[];
  bool isEventDetailImageLoading = false;
  bool hasEventsLoaded = false;

  late NotificationSettings settings;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String get token {
    if (_token.isNotEmpty && JwtDecoder.isExpired(_token)) {
      _token = '';
    }
    return _token;
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
      processFirebaseNotification(message);
    });
  }

  void processFirebaseNotification(RemoteMessage message) {
    // Parse the message received
    //_totalNotifications++;
    notifyListeners();
  }

  getFcmToken() async {
    fcmToken = await messaging.getToken().then((value) => fcmToken = value!);
    await userService.registerFcmToken(fcmToken, token);
    log('posted fcm token');
    //post request
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token') ?? '';
    _refreshToken = prefs.getString('refreshToken') ?? '';
    _username = prefs.getString('username') ?? '';
    eventsLimit = prefs.getInt('eventsLimit') ?? 20;

    //evaluate if jwt token is valid
    if (_token.isEmpty || JwtDecoder.isExpired(_token)) {
      prefs.remove('token');
      _token = '';
    }

    if (_token.isEmpty && _refreshToken.isNotEmpty && _username.isNotEmpty) {
      await processSilentLogin();
    }
    loadingApp = false;
    notifyListeners();
  }

  Future<void> setSettings({int? limit}) async {
    final prefs = await SharedPreferences.getInstance();
    if (limit != null) {
      eventsLimit = limit;
      prefs.setInt('eventsLimit', limit);
    }
    notifyListeners();
  }

  Future<void> setToken(String token, String refreshToken, String? username) async {
    final prefs = await SharedPreferences.getInstance();
    _token = token;
    _refreshToken = refreshToken;
    _username = username ?? _username;
    prefs.setString('token', token);
    prefs.setString('refreshToken', refreshToken);
    prefs.setString('username', username ?? '');
    notifyListeners();
  }

  Future<void> processLogin(BuildContext context, String username, String password) async {
    loggingIn = true;

    try {
      TokenModel token = await UserService().login(username, password);
      setToken(token.accessToken, token.refreshToken, username);
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
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    loggingIn = false;
    getFcmToken();
  }

  Future<void> processSilentLogin() async {
    try {
      TokenModel token = await UserService().refresh(username: _username, refreshToken: _refreshToken);
      await setToken(token.accessToken, token.refreshToken, _username);
    } catch (e) {
      log(e.toString());
      await logout();
    }
    loggingIn = false;
    getFcmToken();
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    setToken('', '', '');
    prefs.setString('token', '');
    prefs.setString('refreshToken', '');
    prefs.setString('username', '');
    notifyListeners();
  }

  Future<void> sendNotification(String title, String body) async {
    await Notifications.showNotification(flutterLocalNotificationsPlugin, title, body);
    notifyListeners();
  }

  Future<void> getEvents({bool forceRefresh = false}) async {
    CameraEventQueryParams params = CameraEventQueryParams(limit: eventsLimit);

    if (forceRefresh || !hasEventsLoaded) {
      isEventsLoading = true;
      try {
        var eventsRequest = await eventService.getEvents(_token, params);
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
      var image = await EventService().getSnapshot(_token, eventId);
      return image;
    } catch (e) {
      log(e.toString());
    } finally {
      isEventDetailImageLoading = false;
    }
    throw Exception('Failed to load snapshot');
  }
}
