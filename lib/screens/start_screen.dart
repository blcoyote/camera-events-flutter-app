import 'package:camera_events/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'event_screen.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  static const routeName = '/StartScreen';
  @override
  State<StartScreen> createState() => _StartScreenState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  navigatorKey.currentState?.pushReplacementNamed(message.data['path']);
}

class _StartScreenState extends State<StartScreen> {
  
  @override
  void initState() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    Stream<RemoteMessage> stream = FirebaseMessaging.onMessageOpenedApp;
    stream.listen((RemoteMessage event) async {
      if (event.data.isNotEmpty) {
        await Navigator.of(context).pushReplacementNamed(event.data['path'],
            arguments: event.data['id']);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Builder(builder: (context) {
      if (appState.loadingApp) {
        return const LoadingScreen();
      }
      if (appState.token.isEmpty) {
        return const LoginScreen();
      }
      return const EventScreen();
    });
  }
}
