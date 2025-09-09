import 'dart:convert';
import 'dart:io';
import 'package:athena/models/addBook.dart';
import 'package:athena/models/borrowBook.dart';
import 'package:athena/models/deleteBookModel.dart';
import 'package:athena/models/history_book.dart';
import 'package:athena/models/list_book.dart';
import 'package:athena/models/put_book.dart';
import 'package:athena/models/updateBookModel.dart';
import 'package:athena/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'endpoint.dart';

class BookApi {
  // Header dengan token
  static Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await SharedPreferencesHelper.getToken();
    if (token == null) throw Exception("No token found, please login first");

    final headers = {
      if (json) "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    return headers;
  }

  // General request handler
  static Future<http.Response> _request(
    Future<http.Response> Function() fn,
  ) async {
    try {
      final response = await fn().timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        // Coba parsing error message dari response
        String errorMessage = "Unknown error occurred";
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          errorMessage =
              errorResponse['message'] ??
              errorResponse['error'] ??
              response.body;
        } catch (e) {
          errorMessage = response.body;
        }
        throw Exception("HTTP ${response.statusCode}: $errorMessage");
      }
    } on http.ClientException catch (e) {
      throw Exception("Network error: $e");
    } on SocketException catch (e) {
      throw Exception("Connection error: $e");
    } catch (e) {
      throw Exception("Request failed: $e");
    }
  }

  // Add book
  static Future<Addbook> addBook({
    required String title,
    required String author,
    required int stock,
    String? coverUrl,
    int? categoryId,
    String? description,
    String? isbn,
  }) async {
    try {
      final response = await _request(() async {
        final body = {"title": title, "author": author, "stock": stock};

        // Tambahkan field opsional hanya jika tidak null
        if (coverUrl != null) body["cover_url"] = coverUrl;
        if (categoryId != null) body["category_id"] = categoryId.toString();
        if (description != null) body["description"] = description;
        if (isbn != null) body["isbn"] = isbn;

        return http.post(
          Uri.parse(Endpoint.books),
          headers: await _headers(json: true),
          body: jsonEncode(body),
        );
      });

      return addbookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Get all books dengan paging, search, dan filter
  static Future<Listbook> getBooks({
    int page = 1,
    int limit = 20,
    String search = "",
    int? categoryId,
    String sortBy = "title",
    String sortOrder = "asc",
  }) async {
    try {
      var queryParams = {
        "page": page.toString(),
        "limit": limit.toString(),
        "search": search,
        "sort_by": sortBy,
        "sort_order": sortOrder,
      };

      if (categoryId != null) {
        queryParams["category_id"] = categoryId.toString();
      }

      final uri = Uri.parse(
        Endpoint.books,
      ).replace(queryParameters: queryParams);

      final response = await _request(() async {
        return http.get(uri, headers: await _headers());
      });

      return listbookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Get popular books
  static Future<Listbook> getPopularBooks({int limit = 10}) async {
    try {
      final uri = Uri.parse(
        Endpoint.booksPopular,
      ).replace(queryParameters: {"limit": limit.toString()});

      final response = await _request(() async {
        return http.get(uri, headers: await _headers());
      });

      return listbookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Get recent books
  static Future<Listbook> getRecentBooks({int limit = 10}) async {
    try {
      final uri = Uri.parse(
        Endpoint.booksRecent,
      ).replace(queryParameters: {"limit": limit.toString()});

      final response = await _request(() async {
        return http.get(uri, headers: await _headers());
      });

      return listbookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Get book by ID
  static Future<Addbook> getBookById(int id) async {
    try {
      final response = await _request(() async {
        return http.get(
          Uri.parse(Endpoint.bookDetail(id)),
          headers: await _headers(),
        );
      });

      return addbookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Update book
  static Future<UpdateBook> updateBook({
    required int id,
    required String title,
    required String author,
    required int stock,
    String? coverUrl,
    int? categoryId,
    String? description,
    String? isbn,
  }) async {
    try {
      final response = await _request(() async {
        final body = {"title": title, "author": author, "stock": stock};

        // Tambahkan field opsional hanya jika tidak null
        if (coverUrl != null) body["cover_url"] = coverUrl;
        if (categoryId != null) body["category_id"] = categoryId.toString();
        if (description != null) body["description"] = description;
        if (isbn != null) body["isbn"] = isbn;

        return http.put(
          Uri.parse(Endpoint.updateBook(id)),
          headers: await _headers(json: true),
          body: jsonEncode(body),
        );
      });

      return updateBookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Delete book
  static Future<DeleteBook> deleteBook(int id) async {
    try {
      final response = await _request(() async {
        return http.delete(
          Uri.parse(Endpoint.deleteBook(id)),
          headers: await _headers(),
        );
      });
      return deleteBookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Borrow book
  static Future<BorrowBook> borrowBook(
    int bookId, {
    DateTime? borrowDate,
  }) async {
    try {
      final response = await _request(() async {
        final body = {"book_id": bookId.toString()};

        if (borrowDate != null) {
          body["borrow_date"] = borrowDate.toIso8601String();
        }

        return http.post(
          Uri.parse(Endpoint.borrow),
          headers: await _headers(json: true),
          body: jsonEncode(body),
        );
      });

      return borrowBookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Return book
  static Future<PutBook> returnBook(
    int borrowId, {
    DateTime? returnDate,
  }) async {
    try {
      final response = await _request(() async {
        final body = {};

        if (returnDate != null) {
          body["return_date"] = returnDate.toIso8601String();
        }

        return http.put(
          Uri.parse(Endpoint.returnBook(borrowId)),
          headers: await _headers(json: true),
          body: jsonEncode(body),
        );
      });

      return putBookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Get my borrows (active)
  static Future<Historybook> getMyBorrows() async {
    try {
      final response = await _request(() async {
        return http.get(
          Uri.parse(Endpoint.myBorrows),
          headers: await _headers(),
        );
      });

      return historybookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Get borrow history
  static Future<Historybook> getBorrowHistory() async {
    try {
      final response = await _request(() async {
        return http.get(
          Uri.parse(Endpoint.myHistory),
          headers: await _headers(),
        );
      });

      return historybookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Upload book cover image
  static Future<String> uploadBookCover(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoint.uploadCover),
      );

      request.headers.addAll(await _headers());
      request.files.add(
        await http.MultipartFile.fromPath(
          'cover',
          imageFile.path,
          filename: 'book_cover_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        return jsonResponse['url'] ??
            jsonResponse['path'] ??
            jsonResponse['image_url'];
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get borrow detail
  static Future<Historybook> getBorrowDetail(int borrowId) async {
    try {
      final response = await _request(() async {
        return http.get(
          Uri.parse(Endpoint.borrowDetail(borrowId)),
          headers: await _headers(),
        );
      });

      return historybookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
