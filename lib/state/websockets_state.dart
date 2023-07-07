import 'package:camera_events/state/app_state.dart';
import 'package:flutter/material.dart';
import '../services/websockets.dart';
import '../app_config.dart';

class WebsocketState extends ChangeNotifier {
  // Basic state for the app
  String token = '';
  late final WebSocketManager webSocketManager;

  WebsocketState(AppState of) {
    token = of.token;

    var headers = {'Authentication': 'Bearer $token'};
    webSocketManager =
        WebSocketManager(url: AppConfig.baseUrl, headers: headers);
  }
}
