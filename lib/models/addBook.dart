// To parse this JSON data, do
//
//     final addbook = addbookFromJson(jsonString);

import 'dart:convert';

Addbook addbookFromJson(String str) => Addbook.fromJson(json.decode(str));

String addbookToJson(Addbook data) => json.encode(data.toJson());

class Addbook {
  String? message;
  Data? data;

  Addbook({this.message, this.data});

  factory Addbook.fromJson(Map<String, dynamic> json) => Addbook(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  String? title;
  String? author;
  int? stock;
  String? coverPath;
  String? coverUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.title,
    this.author,
    this.stock,
    this.coverPath,
    this.coverUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    author: json["author"],
    stock: json["stock"],
    coverPath: json["cover_path"],
    coverUrl: json["cover_url"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "stock": stock,
    "cover_path": coverPath,
    "cover_url": coverUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
