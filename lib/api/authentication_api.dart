import 'dart:convert';
import 'package:athena/models/user_models.dart';
import 'package:athena/preference/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthenticationAPI {
  static const String baseUrl = "https://appperpus.mobileprojp.com/api";

  static Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
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

        // Simpan token & userId
        await SharedPreferencesHelper.saveToken(user.data.token);
        await SharedPreferencesHelper.saveUser(
          id: user.data.user.id,
          name: user.data.user.name,
          email: user.data.user.email,
        );

        return user;
      } else {
        print("Register gagal: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error registerUser: $e");
      return null;
    }
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final user = userModelFromJson(response.body);

        // Simpan token & userId
        await SharedPreferencesHelper.saveToken(user.data.token);
        await SharedPreferencesHelper.saveUser(
          id: user.data.user.id,
          name: user.data.user.name,
          email: user.data.user.email,
        );

        return user;
      } else {
        print("Login gagal: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error loginUser: $e");
      return null;
    }
  }

  static Future<void> logout() async {
    await SharedPreferencesHelper.clearAll();
  }

  static Future<String?> getToken() async => SharedPreferencesHelper.getToken();
  static Future<String?> getUserName() async =>
      SharedPreferencesHelper.getUserName();
  static Future<String?> getUserEmail() async =>
      SharedPreferencesHelper.getUserEmail();
  static Future<int?> getUserId() async => SharedPreferencesHelper.getUserId();
}
