import 'package:flutter/material.dart';
import '../components/event_card.dart';
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
    var eventsRequest = await EventService().getEvents(token);

    setState(() {
      events = eventsRequest;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text('Events')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: events!.length,
                itemBuilder: (context, index) {
                  return EventCard(
                    camera: events![index].camera,
                    startTime: events![index].startTime,
                    thumbnail: events![index].thumbnail,
                  );
                },
              ));
  }
}

