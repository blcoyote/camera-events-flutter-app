import 'dart:developer';
import 'dart:typed_data';
import 'package:camera_events/state/app_state.dart';
import 'package:flutter/material.dart';
import '../models/event.model.dart';
import '../services/event_api.dart';

class EventState extends ChangeNotifier {
  // Basic state for the app
  String token = '';
  bool isEventsLoading = false;
  bool isEventsError = false;
  String eventsErrorMessage = '';
  List<EventModel> events = <EventModel>[];
  bool isEventDetailImageLoading = false;
  bool hasEventsLoaded = false;
  EventService eventService = EventService();

  EventState(AppState of) {
    token = of.token;
  }

  Future<void> getEvents({bool forceRefresh = false}) async {
    if (forceRefresh || !hasEventsLoaded) {
      isEventsLoading = true;
      try {
        var eventsRequest = await eventService.getEvents(token);
        if (eventsRequest == null) {
          throw Exception(eventsErrorMessage);
        }
        events = eventsRequest;
      } catch (e) {
        isEventsError = true;
        eventsErrorMessage = e.toString();
      } finally {
        isEventsLoading = false;
        hasEventsLoaded = true;

        notifyListeners();
      }
    }
  }

  Future<Uint8List> getSnapshot(String eventId) async {
    isEventDetailImageLoading = true;
    try {
      var image = await EventService().getSnapshot(token, eventId);
      return image;
    } catch (e) {
      log(e.toString());
    } finally {
      isEventDetailImageLoading = false;
    }
    throw Exception('Failed to load snapshot');
  }
}
