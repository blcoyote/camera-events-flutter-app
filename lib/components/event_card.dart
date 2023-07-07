import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/event.model.dart';
import 'event_details.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(event.startTime * 1000);
    var convertedDate = DateFormat('dd-MMM-yyyy HH:mm:ss').format(date);
    Uint8List bytesImage = const Base64Decoder().convert(event.thumbnail!);

    return Center(
      key: UniqueKey(),
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.memory(
                bytesImage,
              ),
              title: Text(convertedDate),
              subtitle: Text('camera: ${event.camera}'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetails(event: event)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
