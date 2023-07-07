import 'package:camera_events/utilities.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'dart:developer';
import '../models/event.model.dart';

class EventService {
  Future<List<EventModel>?> getEvents(String token,
      [CameraEventQueryParams? queryParams]) async {
    final headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      //TODO: test query parameters
      var params = queryParams?.toJson();
      var uri =
          urlFormatter(AppConfig.baseUrl, AppConfig.eventEndpoint, params);

      //var url = Uri.parse(AppConfig.baseUrl + AppConfig.eventEndpoint);

      var response = await http.get(uri, headers: headerList);

      if (response.statusCode == 200) {
        List<EventModel> model = eventModelFromJson(response.body);
        return model;
      }
      throw Exception(
          'Failed to load events, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

class EventModelQueryParameters {}
