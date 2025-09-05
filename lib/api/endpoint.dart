class Endpoint {
  static const String baseURL = "https://appperpus.mobileprojp.com/api";

  // Auth
  static const String register = "$baseURL/register";
  static const String login = "$baseURL/login";
  static const String profile =
      "$baseURL/profile"; // untuk lihat & update profile

  // Buku
  static const String books = "$baseURL/books";
  static String updateBook(int id) => "$baseURL/books/$id";
  static String deleteBook(int id) => "$baseURL/books/$id";

  // Peminjaman
  static const String borrow = "$baseURL/borrow";
  static String returnBook(int borrowId) => "$baseURL/borrow/$borrowId/return";

  // History
  static String history(int userId) => "$baseURL/history/$userId";

  // Opsional: kalau lo mau tambah fitur lain nanti
  // static const String someFeature = "$baseURL/some-feature";
}
