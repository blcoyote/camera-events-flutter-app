import 'package:camera_events/state/event_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/event_card.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<EventState>();

    if (appState.events.isEmpty &&
        !appState.isEventsLoading &&
        !appState.isEventsError) {
      appState.getEvents();
    }

    return appState.isEventsLoading
        ? const Center(
            //TODO: this could be better
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: appState.events.length,
            itemBuilder: (context, index) {
              return EventCard(
                camera: appState.events[index].camera,
                startTime: appState.events[index].startTime,
                thumbnail: appState.events[index].thumbnail,
              );
            },
          );
  }
}
