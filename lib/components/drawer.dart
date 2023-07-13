import 'package:camera_events/screens/event_screen.dart';
import 'package:camera_events/screens/settings_screen.dart';
import 'package:camera_events/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

Drawer buildDrawer(BuildContext context) {
  final appState = context.watch<AppState>();
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Camera Events', style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(
          title: const Text('Events'),
          onTap: () {
            Navigator.pushReplacementNamed(context, EventScreen.routeName);
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            Navigator.pushReplacementNamed(context, SettingsScreen.routeName);
          },
        ),
        ListTile(
          title: const Text('Logout'),
          onTap: () {
            appState.logout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StartScreen()),
            );
          },
        ),
      ],
    ),
  );
}
