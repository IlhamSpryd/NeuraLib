// auth_api.dart
import 'dart:convert';
import 'package:athena/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'endpoint.dart';
import '../models/user_models.dart';

class AuthApi {
  // Register user
  static Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.register),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = userModelFromJson(response.body);

        await SharedPreferencesHelper.saveToken(user.data.token);
        await SharedPreferencesHelper.saveUser(
          id: user.data.user.id,
          name: user.data.user.name,
          email: user.data.user.email,
        );

        return user;
      } else {
        throw Exception("Register failed: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  static Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.login),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final user = userModelFromJson(response.body);

        await SharedPreferencesHelper.saveToken(user.data.token);
        await SharedPreferencesHelper.saveUser(
          id: user.data.user.id,
          name: user.data.user.name,
          email: user.data.user.email,
        );

        return user;
      } else {
        throw Exception("Login failed: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      if (token != null) {
        await http.post(
          Uri.parse("${Endpoint.baseURL}/logout"),
          headers: {"Authorization": "Bearer $token"},
        );
      }
      await SharedPreferencesHelper.clearAll();
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  static Future<String?> getUserName() async {
    return await SharedPreferencesHelper.getUserName();
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    return await SharedPreferencesHelper.getUserEmail();
  }

  // Update user profile
  static Future<UserModel?> updateUser({
    required String name,
    required String email,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getToken();
      if (token == null) throw Exception("No token found");

      final response = await http.put(
        Uri.parse(Endpoint.profile),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"name": name, "email": email}),
      );

      if (response.statusCode == 200) {
        final user = userModelFromJson(response.body);

        await SharedPreferencesHelper.saveUser(
          id: user.data.user.id,
          name: user.data.user.name,
          email: user.data.user.email,
        );

        return user;
      } else {
        throw Exception("Update failed: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
