import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({required this.id, required this.username, required this.fullname, required this.email, required this.disabled});
  final String id;
  final String username;
  final String fullname;
  final String email;
  final bool disabled;
 
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        fullname: json["full_name"],
        username: json["username"],
        email: json["email"],
        disabled: json["disabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullname,
        "username": username,
        "email": email,
        "disabled": disabled,
      };
}
