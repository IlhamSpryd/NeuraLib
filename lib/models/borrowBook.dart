// To parse this JSON data, do
//
//     final borrowBooksResponse = borrowBooksResponseFromJson(jsonString);

import 'dart:convert';

BorrowBooksResponse borrowBooksResponseFromJson(String str) =>
    BorrowBooksResponse.fromJson(json.decode(str));

String borrowBooksResponseToJson(BorrowBooksResponse data) =>
    json.encode(data.toJson());

class BorrowBooksResponse {
  String message;
  Data data;

  BorrowBooksResponse({required this.message, required this.data});

  factory BorrowBooksResponse.fromJson(Map<String, dynamic> json) =>
      BorrowBooksResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int userId;
  int bookId;
  DateTime borrowDate;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.userId,
    required this.bookId,
    required this.borrowDate,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    bookId: json["book_id"],
    borrowDate: DateTime.parse(json["borrow_date"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "book_id": bookId,
    "borrow_date": borrowDate.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
