// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({required this.data, required this.message});

  final Data data;
  final String message;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(data: Data.fromJson(json["data"]), message: json["message"]);

  Map<String, dynamic> toJson() => {"data": data.toJson(), "message": message};
}

class Data {
  Data({required this.token, required this.user});

  final String token;
  final User user;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"], user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"token": token, "user": user.toJson()};
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
