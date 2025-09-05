// To parse this JSON data, do
//
//     final historyBook = historyBookFromJson(jsonString);

import 'dart:convert';

HistoryBook historyBookFromJson(String str) =>
    HistoryBook.fromJson(json.decode(str));

String historyBookToJson(HistoryBook data) => json.encode(data.toJson());

class HistoryBook {
  String? message;
  List<Datum>? data;

  HistoryBook({this.message, this.data});

  factory HistoryBook.fromJson(Map<String, dynamic> json) => HistoryBook(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? userId;
  String? bookId;
  DateTime? borrowDate;
  dynamic returnDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Book? book;

  Datum({
    this.id,
    this.userId,
    this.bookId,
    this.borrowDate,
    this.returnDate,
    this.createdAt,
    this.updatedAt,
    this.book,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    bookId: json["book_id"],
    borrowDate: json["borrow_date"] == null
        ? null
        : DateTime.parse(json["borrow_date"]),
    returnDate: json["return_date"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    book: json["book"] == null ? null : Book.fromJson(json["book"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "book_id": bookId,
    "borrow_date":
        "${borrowDate!.year.toString().padLeft(4, '0')}-${borrowDate!.month.toString().padLeft(2, '0')}-${borrowDate!.day.toString().padLeft(2, '0')}",
    "return_date": returnDate,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "book": book?.toJson(),
  };
}

class Book {
  int? id;
  String? title;
  String? author;
  int? stock; // ✅ Ubah dari String? menjadi int?
  DateTime? createdAt;
  DateTime? updatedAt;

  Book({
    this.id,
    this.title,
    this.author,
    this.stock, // ✅ Sekarang int?
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    author: json["author"],
    // ✅ FIX: Handle both String and int for stock
    stock: _parseStock(json["stock"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  // ✅ Helper method untuk parse stock
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
  };
}
