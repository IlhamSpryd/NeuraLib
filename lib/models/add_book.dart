import 'dart:convert';

AddBook addBookFromJson(String str) => AddBook.fromJson(json.decode(str));
String addBookToJson(AddBook data) => json.encode(data.toJson());

class AddBook {
  String? message;
  Data? data;

  AddBook({this.message, this.data});

  factory AddBook.fromJson(Map<String, dynamic> json) => AddBook(
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
  DateTime? updatedAt;
  DateTime? createdAt;
  String? coverUrl;

  Data({
    this.id,
    this.title,
    this.author,
    this.stock,
    this.updatedAt,
    this.createdAt,
    this.coverUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    author: json["author"],
    stock: json["stock"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "stock": stock,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "coverUrl": coverUrl,
  };
}
