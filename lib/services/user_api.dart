import 'package:camera_events/models/token.model.dart';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import 'dart:developer';
import '../models/user.model.dart';
import '../utils/url_formatter.dart';

class UserService {
  Future<List<UserModel>?> getUsers() async {
    try {
      var url = urlFormatter(AppConfig.baseUrl, AppConfig.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<UserModel> model = userModelFromJson(response.body);
        return model;
      }
      throw Exception(
          'Failed to load users, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<TokenModel> login(String username, String password) async {
    const headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = <String, String>{
      'username': username,
      'password': password,
    };
    try {
      var url = urlFormatter(AppConfig.baseUrl, AppConfig.loginEndpoint);
      var response = await http.post(url, headers: headerList, body: body);
      if (response.statusCode == 200) {
        TokenModel token = tokenModelFromJson(response.body);
        return token;
      }
      throw Exception(
          'Failed to login, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<TokenModel> refresh(String username, String refreshToken) async {
    const headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var params = <String, String>{
      'username': username,
      'token': refreshToken,
    };
    try {
      var url =
          urlFormatter(AppConfig.baseUrl, AppConfig.refreshEndpoint, params);
      var response = await http.post(url, headers: headerList);
      if (response.statusCode == 200) {
        TokenModel token = tokenModelFromJson(response.body);
        return token;
      }
      throw Exception(
          'Failed to login, status code: ${response.statusCode}, ${response.body}');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> registerFcmToken(String fcmToken, String userToken) async {
    final headerList = <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken'
    };
    var params = {'token': fcmToken};
    try {
      var url = urlFormatter(AppConfig.baseUrl, '/fcm', params);
      await http.post(url, headers: headerList);

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
