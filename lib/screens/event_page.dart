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
        !appState.isEventsLoading) {
      appState.getEvents();
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Events')),
        body: RefreshIndicator(
      onRefresh: () => appState.getEvents(),
      child: appState.isEventsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: appState.events.length,
              itemBuilder: (context, index) {
                return EventCard(
                  event: appState.events[index],
                );
              },
            ),

        ));
  }
}
