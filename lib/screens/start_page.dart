import 'package:flutter/material.dart';
import '../components/drawer.dart';
import 'event_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: const EventPage(),
      drawer: buildDrawer(context),
    );    
  }
}
