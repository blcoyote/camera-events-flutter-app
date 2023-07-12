import 'package:camera_events/routes/event_notification.dart';
import 'package:camera_events/screens/login_screen.dart';
import 'package:camera_events/screens/start_screen.dart';
import 'package:camera_events/state/event_state.dart';
import 'package:camera_events/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screens/event_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppState(),
        ),
        // ChangeNotifierProxyProvider<AppState, EventState>(
        //   create: (context) =>
        //       EventState(Provider.of<AppState>(context, listen: false)),
        //   update: (context, appState, eventState) => EventState(appState),
        // ),
        
      ],
      child: Consumer<AppState>(
        builder: (context, state, child) {
          return MaterialApp(
              title: 'Camera Events',
              initialRoute: '/',
              routes: {
                '/': (context) => const StartScreen(),
                LoginScreen.routeName: (context) => const LoginScreen(),
                EventScreen.routeName: (context) => const EventScreen(),
                EventNotificationScreen.routeName: (context) =>
                    const EventNotificationScreen(),
                StartScreen.routeName: (context) => const StartScreen(),
              },
              theme: ThemeData(
                // This is the theme of your application.
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ));
        },
      ),
    );
  }
}
