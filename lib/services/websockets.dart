import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  final String url;
  final Map<String, String> headers;
  late IOWebSocketChannel _channel;
  late StreamSubscription _subscription;
  final StreamController<dynamic> _streamController =
      StreamController<dynamic>.broadcast();
  bool _isConnected = false;

  WebSocketManager({required this.url, required this.headers});

  Stream<dynamic> get stream => _streamController.stream;

  bool get isConnected => _isConnected;

  void connect() {
    _channel = IOWebSocketChannel.connect(url, headers: headers);
    _subscription = _channel.stream.listen((dynamic message) {
      _streamController.add(message);
    }, onError: (dynamic error) {
      _streamController.addError(error);
    }, onDone: () {
      _streamController.close();
      _isConnected = false;
    }, cancelOnError: true);
    _isConnected = true;
  }

  void send(dynamic message) {
    if (!_isConnected) {
      _channel.sink.add(json.encode(message));
    }
  }

  void subscribe(Function(dynamic) onData) {
    _streamController.stream.listen(onData);
  }

  void disconnect() {
    _subscription.cancel();
    _channel.sink.close();
    _isConnected = false;
  }
}
