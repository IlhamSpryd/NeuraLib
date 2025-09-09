// user_api.dart
import 'dart:convert';

import 'package:athena/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user_models.dart';
import 'endpoint.dart';

class UserApi {
  // Header with token
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

  // Get user profile
  static Future<UserModel?> getProfile() async {
    try {
      final response = await _request(() async {
        return http.get(Uri.parse(Endpoint.profile), headers: await _headers());
      });
      return userModelFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  static Future<UserModel?> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final response = await _request(() async {
        return http.put(
          Uri.parse(Endpoint.profile),
          headers: await _headers(json: true),
          body: jsonEncode({"name": name, "email": email}),
        );
      });
      return userModelFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await _request(() async {
        return http.post(Uri.parse(Endpoint.logout), headers: await _headers());
      });
      // Clear token after successful logout request
      await SharedPreferencesHelper.clearToken();
    } catch (e) {
      rethrow;
    }
  }
}
