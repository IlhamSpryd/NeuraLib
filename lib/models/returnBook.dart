import 'dart:convert';

ReturnBooksResponse returnBooksResponseFromJson(String str) =>
    ReturnBooksResponse.fromJson(json.decode(str));

class ReturnBooksResponse {
  final String message;
  final ReturnData data;

  ReturnBooksResponse({required this.message, required this.data});

  factory ReturnBooksResponse.fromJson(Map<String, dynamic> json) {
    return ReturnBooksResponse(
      message: json['message'] ?? '',
      data: ReturnData.fromJson(json['data']),
    );
  }
}

class ReturnData {
  final int id;
  final String userId;
  final String bookId;
  final DateTime borrowDate;
  final DateTime returnDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReturnData({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.borrowDate,
    required this.returnDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReturnData.fromJson(Map<String, dynamic> json) {
    return ReturnData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? '',
      bookId: json['book_id'] ?? '',
      borrowDate: DateTime.parse(json['borrow_date']),
      returnDate: DateTime.parse(json['return_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
