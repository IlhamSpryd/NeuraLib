// borrow_api.dart
import 'dart:convert';
import 'package:athena/preference/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'endpoint.dart';
import '../models/borrow_book.dart';

class BorrowApi {
  // Header dengan token
  static Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await SharedPreferencesHelper.getToken();
    if (token == null) throw Exception("No token found, please login first");
    return {
      if (json) "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // General request handler
  static Future<http.Response> _request(
    Future<http.Response> Function() fn,
  ) async {
    try {
      final response = await fn().timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['message'] ?? response.body;
        throw Exception("HTTP ${response.statusCode}: $errorMessage");
      }
    } catch (e) {
      throw Exception("Request failed: $e");
    }
  }

  // Borrow book
  static Future<BorrowBook?> borrowBook(int bookId) async {
    try {
      final response = await _request(() async {
        return http.post(
          Uri.parse(Endpoint.borrow),
          headers: await _headers(json: true),
          body: jsonEncode({"book_id": bookId}),
        );
      });
      return borrowBookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Return borrowed book
  static Future<BorrowBook?> returnBook(int borrowId) async {
    try {
      final response = await _request(() async {
        return http.post(
          Uri.parse(Endpoint.returnBook(borrowId)),
          headers: await _headers(json: true),
        );
      });
      return borrowBookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
