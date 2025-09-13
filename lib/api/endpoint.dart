class Endpoint {
  static const String baseURL = "https://appperpus.mobileprojp.com/api";

  // Auth
  static const String register = "$baseURL/register";
  static const String login = "$baseURL/login";
  static const String logout = "$baseURL/logout";
  static const String profile = "$baseURL/profile";
  static const String refreshToken = "$baseURL/refresh";

  // Books
  static const String books = "$baseURL/books";
  static String bookDetail(int id) => "$books/$id";
  static String updateBook(int id) => "$books/$id";
  static String deleteBook(int id) => "$books/$id";
  static const String booksSearch = "$books/search";

  // Upload
  static const String uploadImage = "$baseURL/upload-image";
  static const String uploadCover = "$baseURL/upload-cover";

  // Borrow/Return
  static const String borrow = "$baseURL/borrow";
  static String borrowDetail(int id) => "$borrow/$id";
  static String returnBook(int borrowId) => "$borrow/$borrowId/return";
  static const String myBorrows = "$borrow/my";
  static const String borrowsActive = "$borrow/active";

  // History
  static const String history = '$baseURL/history';

  // Users
  static const String users = "$baseURL/users";

  // Settings
  static const String settings = "$baseURL/settings";
  static const String settingsProfile = "$settings/profile";
  static const String settingsPassword = "$settings/password";
}
