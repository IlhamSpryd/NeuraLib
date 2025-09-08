// history_api.dart
import 'dart:convert';
import 'package:athena/preference/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'endpoint.dart';
import '../models/history_book.dart';

class HistoryApi {
  // Header dengan token
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPreferencesHelper.getToken();
    if (token == null) throw Exception("No token found, please login first");
    return {"Authorization": "Bearer $token"};
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

  // Get history by user ID
  static Future<HistoryBook?> getHistory(int userId) async {
    try {
      final response = await _request(() async {
        return http.get(
          Uri.parse(Endpoint.history(userId)),
          headers: await _headers(),
        );
      });
      return historyBookFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Get current user's history
  static Future<HistoryBook?> getMyHistory() async {
    try {
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) throw Exception("User ID not found");

      return await getHistory(userId);
    } catch (e) {
      rethrow;
    }
  }
}
