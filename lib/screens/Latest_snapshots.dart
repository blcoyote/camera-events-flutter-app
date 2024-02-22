import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/drawer.dart';
import '../state/app_state.dart';

class SnapshotViewer extends StatelessWidget {
  final List<String> deviceNames;

  const SnapshotViewer({
    super.key,
    required this.deviceNames,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    getSnapshot(String deviceName) {
      // TODO: replace by REST call
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Latest Snapshots')),
        drawer: buildDrawer(context),
        body: RefreshIndicator(
          onRefresh: () => appState.getEvents(forceRefresh: true), // replace by snap
          child: ListView.builder(
            itemCount: deviceNames.length,
            itemBuilder: (context, index) {
              return FutureBuilder<ImageProvider>(
                future: getSnapshot(deviceNames[index]), // Replace with your REST endpoint call
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading snapshot: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No snapshot found.'),
                    );
                  } else {
                    return ListTile(
                      title: Text(deviceNames[index]),
                      leading: Image(image: snapshot.data!),
                    );
                  }
                },
              );
            },
          ),
        ));
  }
}
