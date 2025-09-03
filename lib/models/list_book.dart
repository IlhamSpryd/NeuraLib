// list_book.dart
// To parse this JSON data, do
//
//     final listBook = listBookFromJson(jsonString);

import 'dart:convert';

ListBookItem listBookItemFromJson(String str) =>
    ListBookItem.fromJson(json.decode(str));

String listBookItemToJson(ListBookItem data) => json.encode(data.toJson());

class ListBookItem {
  String? message;
  List<BookDatum>? data;

  ListBookItem({this.message, this.data});

  factory ListBookItem.fromJson(Map<String, dynamic> json) => ListBookItem(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<BookDatum>.from(json["data"].map((x) => BookDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BookDatum {
  int? id;
  String? title;
  String? author;
  int? stock;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coverUrl;

  BookDatum({
    this.id,
    this.title,
    this.author,
    this.stock,
    this.createdAt,
    this.updatedAt,
    this.coverUrl,
  });

  factory BookDatum.fromJson(Map<String, dynamic> json) => BookDatum(
    id: json["id"],
    title: json["title"],
    author: json["author"],
    stock: json["stock"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    coverUrl: json["cover_url"] != null
        ? "https://appperpus.mobileprojp.com/api${json["cover_url"]}"
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "stock": stock,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "cover_url": coverUrl,
  };
}
