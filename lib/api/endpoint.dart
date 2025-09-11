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
  static const String booksPopular = "$books/popular";
  static const String booksRecent = "$books/recent";
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
  // static const String history = "$baseURL/history";
  // static String userHistory(int userId) => "$history/user/$userId";
  // static const String myHistory = "$history/my";
   static const String history = '$baseURL/history'; // GET riwayat

  // Users
  static const String users = "$baseURL/users";
  static String userDetail(int id) => "$users/$id";
  static String userBorrows(int userId) => "$users/$userId/borrows";
  static String userHistoryEndpoint(int userId) => "$users/$userId/history";

  // Settings
  static const String settings = "$baseURL/settings";
  static const String settingsProfile = "$settings/profile";
  static const String settingsPassword = "$settings/password";
  static const String settingsNotifications = "$settings/notifications";

  
}
