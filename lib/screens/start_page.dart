import 'package:camera_events/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/drawer.dart';
import 'event_page.dart';
import 'loading.dart';
import 'login.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  navigatorKey.currentState?.pushReplacementNamed(message.data['path']);
  print("Handling a background message: ${message.messageId}");
}

class _StartPageState extends State<StartPage> {
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
        return const Loading();
      }
      if (appState.token.isEmpty) {
        return const LoginScreen();
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Camera Events')),
        body: const EventPage(),
        drawer: buildDrawer(context),
          
      );
    }
    );
  }
}


