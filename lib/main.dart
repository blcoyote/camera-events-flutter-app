import 'package:camera_events/routes/event_notification.dart';
import 'package:camera_events/state/websockets_state.dart';
import 'package:camera_events/screens/start_page.dart';
import 'package:camera_events/state/event_state.dart';
import 'package:camera_events/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(),
        ),
        ChangeNotifierProxyProvider<AppState, EventState>(
          create: (context) =>
              EventState(Provider.of<AppState>(context, listen: false)),
          update: (context, appState, eventState) => EventState(appState),
        ),
        ChangeNotifierProxyProvider<AppState, WebsocketState>(
          create: (context) =>
              WebsocketState(Provider.of<AppState>(context, listen: false)),
          update: (context, appState, eventState) => WebsocketState(appState),
        )
      ],
      child: Consumer<AppState>(
        builder: (context, state, child) {
          return MaterialApp(
              title: 'Camera Events',
              initialRoute: '/',
              routes: {
                '/': (context) => const StartPage(),
                '/eventnotification': (context) =>
                    const EventNotificationScreen(),
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
