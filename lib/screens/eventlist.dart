import 'package:flutter/material.dart';
import '../components/event_card.dart';
import '../models/event.model.dart';

class EventList extends StatelessWidget {
  final List<EventModel> events;

  const EventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            camera: events[index].camera,
            startTime: events[index].startTime,
            thumbnail: events[index].thumbnail,
          );
        },
      ),
    );
  }
}
