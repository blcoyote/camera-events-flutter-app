import 'package:camera_events/models/event.model.dart';
import 'package:camera_events/services/notifications.dart';
import 'package:camera_events/services/user_api.dart';
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
  //late final FirebaseAnalytics analytics;
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

  get token {
    if (_token.isNotEmpty && JwtDecoder.isExpired(_token)) {
      return '';
    }
    return _token;
  }

  Future<String> getValidToken() {
    if (_token.isNotEmpty && JwtDecoder.isExpired(_token)) {
      return processSilentLogin().then((value) => _token);
    }
    return Future.value(_token);
  }

  AppState() {
    loadSettings();
    Notifications.initialize(flutterLocalNotificationsPlugin);
    messaging = FirebaseMessaging.instance;
    //analytics = FirebaseAnalytics.instance;
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
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   processFirebaseNotification(message);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   processFirebaseNotification(message);
    // });
  }

  void processFirebaseNotification(RemoteMessage message) {
    // TODO: Parse the message received on open app
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

    eventsLimit = prefs.getInt('eventsLimit') ?? 20;
    _token = prefs.getString('token') ?? '';
    _refreshToken = prefs.getString('refreshToken') ?? '';
    _username = prefs.getString('username') ?? '';

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

  setToken(String token, String refreshToken, String? username) async {
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
      await setToken(token.accessToken, token.refreshToken, username);
      getFcmToken();
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
  }

  Future<void> processSilentLogin() async {
    try {
      TokenModel token = await UserService().refresh(username: _username, refreshToken: _refreshToken);
      await setToken(token.accessToken, token.refreshToken, _username);
      getFcmToken();
    } catch (e) {
      log(e.toString());
      await logout();
    }
  }

  Future<void> logout() async {
    setToken('', '', '');
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
        var eventsRequest = await eventService.getEvents(token, params);
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

  Future<Uint8List> getClip(String eventId) async {
    isEventDetailImageLoading = true;
    try {
      var clip = await EventService().getClip(token, eventId);
      return clip;
    } catch (e) {
      log(e.toString());
    } finally {
      isEventDetailImageLoading = false;
    }
    throw Exception('Failed to load clip');
  }

  Future<EventModel> getEvent(String id) async {
    String token = await getValidToken();

    try {
      var eventsRequest = await eventService.getEvent(token, id.trim());
      if (eventsRequest == null) {
        throw Exception(eventsErrorMessage);
      }
      return eventsRequest;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
