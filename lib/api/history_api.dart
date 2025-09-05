import 'package:athena/preference/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api/endpoint.dart';
import '../models/history_book.dart';

class HistoryApi {
  static const String baseUrl = "https://appperpus.mobileprojp.com/api";

  static Future<HistoryBook?> getHistory(int userId) async {
    final token = await SharedPreferencesHelper.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.history(userId)),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return historyBookFromJson(response.body);
    } else {
      throw Exception("Failed to fetch history");
    }
  }
}
