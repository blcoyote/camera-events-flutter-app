import 'package:flutter/material.dart';

import '../components/drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        drawer: buildDrawer(context),
        body: const Center(
          child: Text('Settings'),
        ));
  }
}
