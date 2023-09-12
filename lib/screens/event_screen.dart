import 'package:camera_events/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/drawer.dart';
import '../components/event_card.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});
  static const routeName = '/events';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.hasEventsLoaded == false) {
      appState.getEvents();
    }


    return Scaffold(
        appBar: AppBar(title: const Text('Camera Events')),
        drawer: buildDrawer(context),
        body: RefreshIndicator(
          onRefresh: () => appState.getEvents(forceRefresh: true),
          child: containerbuilder(context, appState),
        ));
  }
}

containerbuilder(BuildContext context, AppState appState) {


  if (appState.isEventsLoading) {
    //TODO replace by proper loading indicator based on Listview.builder output
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (appState.isEventsError) {
    return Center(
      child: Text(appState.eventsErrorMessage),
    );
  }

  return ListView.builder(
    itemCount: appState.events.length,
    itemBuilder: (context, index) {
      return EventCard(
        event: appState.events[index],
      );
    },
  );  
}
