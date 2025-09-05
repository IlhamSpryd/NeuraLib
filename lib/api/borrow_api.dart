import 'dart:convert';
import 'package:athena/preference/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/endpoint.dart';
import '../models/borrow_book.dart';

class BorrowApi {
  static const String baseUrl = "https://appperpus.mobileprojp.com/api";
  
  // 🔹 Borrow book
  static Future<BorrowBook?> borrowBook({
    required int userId,
    required int bookId,
  }) async {
    final token = await SharedPreferencesHelper.getToken();
    final response = await http.post(
      Uri.parse(Endpoint.borrow),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"user_id": userId, "book_id": bookId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return borrowBookFromJson(response.body);
    } else {
      throw Exception("Failed to borrow book");
    }
  }
}
