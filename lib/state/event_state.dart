import 'package:camera_events/state/app_state.dart';
import 'package:flutter/material.dart';
import '../models/event.model.dart';
import '../services/event_api.dart';

class EventState extends ChangeNotifier {
  // Basic state for the app
  String token = '';

  //TODO: cameraEvent state. Move to separate state file?
  bool isEventsLoading = false;
  bool isEventsError = false;
  String eventsErrorMessage = '';
  List<EventModel> events = <EventModel>[];

  EventState(AppState of) {
    token = of.token;
  }

  Future<void> getEvents() async {
    isEventsLoading = true;
    try {
      var eventsRequest = await EventService().getEvents(token);
      if (eventsRequest == null) {
        throw Exception('Failed to load events');
      }
      events = eventsRequest;
    } catch (e) {
      isEventsError = true;
      eventsErrorMessage = e.toString();
    }
    isEventsLoading = false;

    notifyListeners();
  }
}
