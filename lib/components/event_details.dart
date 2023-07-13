import 'dart:typed_data';
import 'dart:ui';
import 'package:camera_events/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.model.dart';
import '../screens/event_screen.dart';

class EventDetails extends StatelessWidget {
  final EventModel event;

  const EventDetails({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    var date = DateTime.fromMillisecondsSinceEpoch(event.startTime * 1000);
    var convertedDate = DateFormat('dd-MMM-yyyy HH:mm:ss').format(date);

    Future<Uint8List> image = appState.getSnapshot(event.id);

    return FutureBuilder<Uint8List>(
      future: image,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: _buildBackButton(context),
              title: Text(convertedDate),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Camera: ${event.camera}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Event ID: ${event.id}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Object detection label: ${event.label}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Snapshot:',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: InteractiveViewer(
                        panEnabled:
                            false, // Set it to false to prevent panning.
                        boundaryMargin: const EdgeInsets.all(0),
                        minScale: 1,
                        maxScale: 4,
                        child: Image.memory(snapshot.data!)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Snapshot saved to gallery'),
                              action: SnackBarAction(
                                label: 'Close',
                                onPressed: () {
                                  //TODO: Code to execute.
                                },
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.save),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Clip saved to gallery'),
                              action: SnackBarAction(
                                label: 'Close',
                                onPressed: () {
                                  //TODO: Code to execute.
                                },
                              ),
                            ),
                          );
                        },
                        child: const Icon(Icons.movie),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return BackButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, EventScreen.routeName);
      },
    );
  }
}
