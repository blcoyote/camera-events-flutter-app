import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class EventCard extends StatelessWidget {
  final String camera;
  final int startTime;
  final String? thumbnail;

  const EventCard(
      {super.key,
      required this.camera,
      required this.startTime,
      required this.thumbnail});

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
    var convertedDate = DateFormat('dd-MMM-yyyy HH:mm:ss').format(date);
    Uint8List bytesImage = const Base64Decoder().convert(thumbnail!);

    return Center(
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.memory(
                bytesImage,
                width: 200,
                height: 100,
              ),
              title: Text(convertedDate),
              subtitle: Text(camera),
            ),
          ],
        ),
      ),
    );
  }
}
