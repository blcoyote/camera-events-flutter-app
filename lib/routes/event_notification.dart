import 'package:camera_events/components/event_details.dart';
import 'package:camera_events/models/event.model.dart';
import 'package:camera_events/state/app_state.dart';
import 'package:camera_events/services/event_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// A Widget that extracts the necessary arguments from
// the ModalRoute.
class EventNotificationScreen extends StatelessWidget {
  const EventNotificationScreen({super.key});

  static const routeName = '/eventnotification';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final AppState appState = context.watch<AppState>();
    EventService eventService = EventService();


    return FutureBuilder<EventModel>(
      future: eventService.getEvent(appState.token, id.trim()),
        builder: (BuildContext context, AsyncSnapshot<EventModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final event = snapshot.data!;
              return EventDetails(event: event);
            }
          } else {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Loading event details...'),
              ],
            ),
          );
          }
      },
    );

  }
}
