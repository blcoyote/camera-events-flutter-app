import 'dart:typed_data';
import 'package:camera_events/state/app_state.dart';
import 'package:camera_events/utils/file_access.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.model.dart';
import '../screens/event_screen.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;

  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool _isVideoDownloaded = false;

  playControllerCheck() {
    if (checkFileExists('${widget.event.id}.mp4')) {
      setState(() {
        _isVideoDownloaded = true;
      });
    } else {
      _isVideoDownloaded = false;
    }
  }

  @override
  void initState() {
    super.initState();
    playControllerCheck();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    var date = DateTime.fromMillisecondsSinceEpoch(widget.event.startTime.toInt() * 1000);
    var convertedDate = DateFormat('dd-MMM-yyyy HH:mm:ss').format(date);

    return FutureBuilder<Uint8List>(
      future: appState.getSnapshot(widget.event.id),
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
                    'Camera: ${widget.event.camera}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Event ID: ${widget.event.id}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Object detection label: ${widget.event.label}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Probability: ${((widget.event.data?.score ?? 0) * 100).toStringAsFixed(3)}%',
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
                        panEnabled: false, // Set it to false to prevent panning.
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
                          writeFile(snapshot.data!, '${widget.event.id}.jpg')
                              .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Snapshot saved to downloads'),
                                      action: SnackBarAction(
                                        label: 'Close',
                                        onPressed: () {
                                          //do nothing
                                        },
                                      ),
                                    ),
                                  ))
                              .catchError((onError) => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Unable to save snapshot'),
                                      action: SnackBarAction(
                                        label: 'Close',
                                        onPressed: () {
                                          //do nothing
                                        },
                                      ),
                                    ),
                                  ));
                        },
                        child: const Icon(Icons.save),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_isVideoDownloaded) {
                            openVideo('${widget.event.id}.mp4');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Saving clip to Downloads...'),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    //do nothing
                                  },
                                ),
                              ),
                            );
                            appState.getClip(widget.event.id).then((value) => writeFile(value, '${widget.event.id}.mp4')
                                .then((value) => {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Clip saved to Downloads'),
                                          action: SnackBarAction(
                                            label: 'Show clip',
                                            onPressed: () {
                                              openVideo('${widget.event.id}.mp4');
                                            },
                                          ),
                                        ),
                                      ),
                                      playControllerCheck()
                                    })
                                .catchError((onError) => {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Unable to save clip'),
                                          action: SnackBarAction(
                                            label: 'Close',
                                            onPressed: () {
                                              //do nothing
                                            },
                                          ),
                                        ),
                                      )
                                    }));
                          }
                        },
                        child: _isVideoDownloaded ? const Icon(Icons.play_arrow) : const Icon(Icons.movie),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ));
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
