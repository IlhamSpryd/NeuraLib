// list_book.dart
import 'dart:convert';

ListBookItem listBookItemFromJson(String str) =>
    ListBookItem.fromJson(json.decode(str));
String listBookItemToJson(ListBookItem data) => json.encode(data.toJson());

class ListBookItem {
  String? message;
  List<BookDatum>? data;
  Meta? meta;

  ListBookItem({this.message, this.data, this.meta});

  factory ListBookItem.fromJson(Map<String, dynamic> json) => ListBookItem(
    message: json["message"],
    data: json["data"] == null || json["data"]["items"] == null
        ? []
        : List<BookDatum>.from(
            json["data"]["items"]!.map((x) => BookDatum.fromJson(x)),
          ),
    meta: json["data"] == null || json["data"]["meta"] == null
        ? null
        : Meta.fromJson(json["data"]["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "meta": meta?.toJson(),
  };
}

class BookDatum {
  int? id;
  String? title;
  String? author;
  int? stock;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? coverPath;
  String? coverUrl;

  BookDatum({
    this.id,
    this.title,
    this.author,
    this.stock,
    this.createdAt,
    this.updatedAt,
    this.coverPath,
    this.coverUrl,
  });

  factory BookDatum.fromJson(Map<String, dynamic> json) => BookDatum(
    id: json["id"],
    title: json["title"],
    author: json["author"],
    stock: _parseStock(json["stock"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    coverPath: json["cover_path"],
    coverUrl: json["cover_url"],
  );

  // Helper method untuk parse stock
  static int? _parseStock(dynamic stockValue) {
    if (stockValue == null) return null;

    if (stockValue is int) {
      return stockValue;
    } else if (stockValue is String) {
      return int.tryParse(stockValue);
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "stock": stock,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "cover_path": coverPath,
    "cover_url": coverUrl,
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
