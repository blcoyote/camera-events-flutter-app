import 'package:camera_events/screens/loading.dart';
import 'package:camera_events/screens/startpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool loadingApp = true;
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  //Loading stored token value on start
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();

    //evaluate if jwt token is valid
    var token = prefs.getString('token') ?? '';
    if (token.isEmpty || JwtDecoder.isExpired(token)) {
      prefs.remove('token');
      token = '';
    }

    setState(() {
      this.token = token;
      loadingApp = false;
    });
  }

  Future<void> _setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      this.token = token;
    });
    prefs.setString('token', token);
  }

  void setLoggedIn(String token) {
    _setToken(token);
  }

  @override
  Widget build(BuildContext context) {
    Widget selectHome() {
      if (loadingApp) {
        return const Loading();
      }
      if (token.isNotEmpty) {
        return StartPage(
          token: token,
        );
      }
      return const LoginScreen();
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: selectHome(),
    );
  }
}
