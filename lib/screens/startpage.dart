import 'package:flutter/material.dart';
import 'eventpage.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        //TODO: Navigation bar
        appBar: AppBar(title: const Text('Events')),
        body: const EventPage());
  }
}
