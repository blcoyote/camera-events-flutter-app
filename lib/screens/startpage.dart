import 'package:camera_events/screens/eventlist.dart';
import 'package:flutter/material.dart';

import '../models/event.model.dart';
import '../services/event_api.dart';


class StartPage extends StatefulWidget {
  final String token;

  const StartPage({required this.token});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<EventModel>? events = <EventModel>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getEvents(widget.token);
  }

  Future<void> getEvents(String token) async {
    events = await EventService().getEvents(token);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text('Events')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : EventList(events: events!)
      );
  }
}

