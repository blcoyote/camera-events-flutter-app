import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/drawer.dart';
import '../state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    //appState.setSettings(limit: 50);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      //TODO: backbutton instead of drawer
      drawer: buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            const Text(
              'Event display limit',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '10',
                  style: TextStyle(fontSize: 16.0),
                ),
                Expanded(
                  child: Slider(
                    value: appState.eventsLimit.toDouble(),
                    min: 10.0,
                    max: 100.0,
                    divisions: 9,
                    onChanged: (value) {
                      appState.setSettings(limit: (value / 10).round() * 10);
                    },
                  ),
                ),
                const Text(
                  '100',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
