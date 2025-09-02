class Endpoint {
  static const String baseURL = "https://appperpus.mobileprojp.com/api";

  static const String register = "$baseURL/register";
  static const String login = "$baseURL/login";
  static const String profile = "$baseURL/profile";

  static const String books = "$baseURL/books";
  static String updateBook(int id) => "$baseURL/books/$id";
  static String deleteBook(int id) => "$baseURL/books/$id";

  static const String borrow = "$baseURL/borrow";
  static String returnBook(int borrowId) => "$baseURL/borrow/$borrowId/return";

  static String history(int userId) => "$baseURL/history/$userId";
}
