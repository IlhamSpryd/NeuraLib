// To parse this JSON data, do
//
//     final historybook = historybookFromJson(jsonString);

import 'dart:convert';

Historybook historybookFromJson(String str) =>
    Historybook.fromJson(json.decode(str));

String historybookToJson(Historybook data) => json.encode(data.toJson());

class Historybook {
  String? message;
  List<Datum>? data;

  Historybook({required this.message, required this.data});

  factory Historybook.fromJson(Map<String, dynamic> json) => Historybook(
    message: json["message"],
    data: List<Datum>.from(
      json["data"].map((x) => Datum.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  int userId;
  int bookId;
  DateTime borrowDate;
  DateTime? returnDate;
  DateTime createdAt;
  DateTime updatedAt;
  Book? book;

  Datum({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.borrowDate,
    required this.returnDate,
    required this.createdAt,
    required this.updatedAt,
    required this.book,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: int.parse(json["id"].toString()),
    userId: int.parse(json["user_id"].toString()),
    bookId: int.parse(json["book_id"].toString()),
    borrowDate: DateTime.parse(json["borrow_date"]),
    returnDate: json["return_date"] == null
        ? null
        : DateTime.parse(json["return_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    book: json["book"] == null ? null : Book.fromJson(json["book"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "book_id": bookId,
    "borrow_date": borrowDate.toIso8601String(),
    "return_date": returnDate?.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "book": book?.toJson(),
  };
}

class Book {
  int id;
  String title;
  String author;
  int stock;
  String? cover;
  DateTime createdAt;
  DateTime updatedAt;
  String? coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.stock,
    this.cover,
    required this.createdAt,
    required this.updatedAt,
    this.coverUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: int.parse(json["id"].toString()),
    title: json["title"].toString(),
    author: json["author"].toString(),
    stock: int.parse(json["stock"].toString()),
    cover: json["cover"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    coverUrl: json["cover_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author": author,
    "stock": stock,
    "cover": cover,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "cover_url": coverUrl,
  };
}
