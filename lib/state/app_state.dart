import 'package:camera_events/services/notifications.dart';
import 'package:camera_events/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/token.model.dart';

class AppState extends ChangeNotifier {
  // Basic state for the app
  String token = '';
  bool loadingApp = true;
  bool loggingIn = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();



  AppState() {
    loadSettings();
    Notifications.initialize(flutterLocalNotificationsPlugin);
    
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
