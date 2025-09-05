import 'dart:convert';
import 'package:athena/models/add_book.dart';
import 'package:athena/models/borrow_book.dart';
import 'package:athena/models/delete_book.dart';
import 'package:athena/models/list_book.dart';
import 'package:athena/models/put_book.dart';
import 'package:athena/models/history_book.dart';
import 'package:athena/preference/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/endpoint.dart';

class BookApi {
  static const String baseUrl = "https://appperpus.mobileprojp.com/api";
  
  // 🔹 Header with token
  static Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await SharedPreferencesHelper.getToken();
    if (token == null) throw Exception("No token found, please login first");
    return {
      if (json) "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // 🔹 General request handler
  static Future<http.Response> _request(
    Future<http.Response> Function() fn,
  ) async {
    try {
      final response = await fn().timeout(const Duration(seconds: 10));
      print('API Response: ${response.statusCode} - ${response.body}');

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

  // 🔹 Get all books with paging & search
  static Future<ListBookItem?> getBooks({
    int page = 1,
    int limit = 20,
    String search = "",
  }) async {
    final uri = Uri.parse(
      "${Endpoint.books}?page=$page&limit=$limit&search=$search",
    );

    final response = await _request(() async {
      return http.get(uri, headers: await _headers());
    });

    final listBook = listBookItemFromJson(response.body);

    // 🔹 Default coverUrl kalau null
    if (listBook.data != null) {
      for (var book in listBook.data!) {
        book.coverUrl ??=
            "https://via.placeholder.com/300x400?text=${Uri.encodeComponent(book.title ?? 'Book')}";
      }
    }

    return listBook;
  }

  // 🔹 Add book
  static Future<AddBook?> addBook({
    required String title,
    required String author,
    required int stock,
  }) async {
    final response = await _request(() async {
      return http.post(
        Uri.parse(Endpoint.books),
        headers: await _headers(json: true),
        body: jsonEncode({"title": title, "author": author, "stock": stock}),
      );
    });
    return addBookFromJson(response.body);
  }

  // 🔹 Update book
  static Future<PutBook?> updateBook({
    required int id,
    required String title,
    required String author,
    required int stock,
  }) async {
    final response = await _request(() async {
      return http.put(
        Uri.parse(Endpoint.updateBook(id)),
        headers: await _headers(json: true),
        body: jsonEncode({"title": title, "author": author, "stock": stock}),
      );
    });
    return putBookFromJson(response.body);
  }

  // 🔹 Delete book
  static Future<DeleteBook?> deleteBook(int id) async {
    final response = await _request(() async {
      return http.delete(
        Uri.parse(Endpoint.deleteBook(id)),
        headers: await _headers(),
      );
    });
    return deleteBookFromJson(response.body);
  }

  // 🔹 Get history sesuai user login
  static Future<HistoryBook?> getHistorySelf() async {
    final userId = await SharedPreferencesHelper.getUserId();
    if (userId == null)
      throw Exception("User ID not found, please login first");

    final response = await _request(() async {
      return http.get(
        Uri.parse(Endpoint.history(userId)),
        headers: await _headers(),
      );
    });
    return historyBookFromJson(response.body);
  }

  // 🔹 Borrow book
  static Future<BorrowBook?> borrowBook(int bookId) async {
    final response = await _request(() async {
      return http.post(
        Uri.parse(Endpoint.borrow),
        headers: await _headers(json: true),
        body: jsonEncode({"book_id": bookId}),
      );
    });
    return borrowBookFromJson(response.body);
  }

  // 🔹 Return borrowed book
  static Future<BorrowBook?> returnBook(int borrowId) async {
    final response = await _request(() async {
      return http.post(
        Uri.parse(Endpoint.returnBook(borrowId)),
        headers: await _headers(json: true),
      );
    });
    return borrowBookFromJson(response.body);
  }
}
