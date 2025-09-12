// To parse this JSON data, do
//
//     final listbook = listbookFromJson(jsonString);

import 'dart:convert';

Listbook listbookFromJson(String str) => Listbook.fromJson(json.decode(str));

String listbookToJson(Listbook data) => json.encode(data.toJson());

class Listbook {
  String? message;
  Data? data;

  Listbook({this.message, this.data});

  factory Listbook.fromJson(Map<String, dynamic> json) => Listbook(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  List<Item>? items;
  Meta? meta;

  Data({required this.items, required this.meta});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class Item {
  int? id;
  String? title;
  String? author;
  int? stock;
  String? coverPath;
  String? coverUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Item({
    this.id,
    this.title,
    this.author,
    this.stock,
    this.coverPath,
    this.coverUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: _parseToInt(json["id"]),
    title: json["title"],
    author: json["author"],
    stock: _parseToInt(json["stock"]),
    coverPath: json["cover_path"],
    coverUrl: json["cover_url"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
  );
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

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

class Meta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Meta({this.currentPage, this.lastPage, this.perPage, this.total});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}
