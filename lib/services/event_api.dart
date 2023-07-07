import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'dart:developer';
import '../models/event.model.dart';

class EventService {
  Future<List<EventModel>?> getEvents(String token) async {
    final headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      //TODO: test query parameters
      var params = CameraEventQueryParams().toJson();
      var uri = Uri.http(AppConfig.baseUrl, AppConfig.eventEndpoint, params);

      var url = Uri.parse(AppConfig.baseUrl + AppConfig.eventEndpoint);

      var response = await http.get(url, headers: headerList);

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
