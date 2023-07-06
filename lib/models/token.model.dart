
import 'dart:convert';

TokenModel tokenModelFromJson(String str) =>
    TokenModel.fromJson(json.decode(str));


class TokenModel {
  TokenModel({required this.accessToken, required this.tokenType});
  final String accessToken;
  final String tokenType;

 
  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );

}

