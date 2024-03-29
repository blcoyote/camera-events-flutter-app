import 'dart:convert';
import 'dart:typed_data';
import 'package:camera_events/utils/url_formatter.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'dart:developer';
import '../models/event.model.dart';

class EventService {

  Future<List<String>>? getCameras(String token) async {
    final headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var uri = urlFormatter(AppConfig.baseUrl, AppConfig.camerasEndpoint);
      var response = await http.get(uri, headers: headerList);
      if (response.statusCode == 200) {
        List<String> cameras = List<String>.from(jsonDecode(response.body));
        return cameras;
      }
      throw Exception('Failed to load cameras, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<EventModel>>? getEvents(String token, [CameraEventQueryParams? queryParams]) async {
    final headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var uri = urlFormatter(AppConfig.baseUrl, AppConfig.eventEndpoint, queryParams?.toJson());
      var response = await http.get(uri, headers: headerList);
      if (response.statusCode == 200) {
        List<EventModel> model = eventModelFromJson(response.body);
        return model;
      }
      throw Exception('Failed to load events, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<EventModel>? getEvent(String token, String id, [CameraEventQueryParams? queryParams]) async {
    final headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var params = queryParams?.toJson();
      var uri = urlFormatter(AppConfig.baseUrl, '${AppConfig.eventEndpoint}$id', params);

      var response = await http.get(uri, headers: headerList);

      if (response.statusCode == 200) {
        EventModel model = eventModelFromJsonSingle(response.body);

        return model;
      }
      throw Exception('Failed to load events, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Uint8List> getSnapshot(String token, String eventId) async {
    final headerList = <String, String>{'Authorization': 'Bearer $token', 'Accept': 'image/jpeg'};
    try {
      var uri = urlFormatter(AppConfig.baseUrl, '${AppConfig.eventEndpoint}$eventId/snapshot.jpg');

      var response = await http.get(uri, headers: headerList);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      throw Exception('Failed to load events, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Uint8List> getClip(String token, String eventId) async {
    final headerList = <String, String>{'Authorization': 'Bearer $token', 'Accept': 'image/jpeg'};
    try {
      var uri = urlFormatter(AppConfig.baseUrl, '${AppConfig.eventEndpoint}$eventId/clip.mp4');

      var response = await http.get(uri, headers: headerList);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      throw Exception('Failed to load events, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
