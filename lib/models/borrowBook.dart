// To parse this JSON data, do
//
//     final borrowBook = borrowBookFromJson(jsonString);

import 'dart:convert';

BorrowBook borrowBookFromJson(String str) =>
    BorrowBook.fromJson(json.decode(str));

String borrowBookToJson(BorrowBook data) => json.encode(data.toJson());

class BorrowBook {
  String? message;
  Data? data;

  BorrowBook({this.message, this.data});

  factory BorrowBook.fromJson(Map<String, dynamic> json) => BorrowBook(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? userId;
  int? bookId;
  DateTime? borrowDate;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.userId,
    this.bookId,
    this.borrowDate,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    bookId: json["book_id"],
    borrowDate: json["borrow_date"] == null
        ? null
        : DateTime.parse(json["borrow_date"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "book_id": bookId,
    "borrow_date": borrowDate?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
