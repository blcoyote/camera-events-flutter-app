import 'package:camera_events/screens/loading.dart';
import 'package:camera_events/screens/start_page.dart';
import 'package:camera_events/state/event_state.dart';
import 'package:flutter/material.dart';
import 'screens/event_page.dart';
import 'screens/login.dart';
import 'package:camera_events/state/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          )
        ],
      child: Consumer<AppState>(
        builder: (context, state, child) {
          return MaterialApp(
          title: 'Camera Events',
              routes: {
                '/start': (context) => const StartPage(),
                '/events': (context) => const EventPage(),
              },
              
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
              home: state.loadingApp
                  ? const Loading()
                  : state.token.isEmpty
                      ? const LoginScreen()
                      : const StartPage());
            },
          ),
    );
  }
}
