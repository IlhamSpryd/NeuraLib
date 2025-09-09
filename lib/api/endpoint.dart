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
  static const String history = "$baseURL/history";
  static String userHistory(int userId) => "$history/user/$userId";
  static const String myHistory = "$history/my";

  // Categories
  static const String categories = "$baseURL/categories";
  static String categoryBooks(int categoryId) =>
      "$categories/$categoryId/books";

  // Users
  static const String users = "$baseURL/users";
  static String userDetail(int id) => "$users/$id";
  static String userBorrows(int userId) => "$users/$userId/borrows";
  static String userHistoryEndpoint(int userId) => "$users/$userId/history";

  // Admin
  static const String admin = "$baseURL/admin";
  static const String adminUsers = "$admin/users";
  static const String adminBooks = "$admin/books";
  static const String adminBorrows = "$admin/borrows";
  static const String adminStats = "$admin/stats";
  static String adminUserDetail(int userId) => "$admin/users/$userId";
  static String adminBookDetail(int bookId) => "$admin/books/$bookId";
  static String adminBorrowDetail(int borrowId) => "$admin/borrows/$borrowId";

  // Reports
  static const String reports = "$baseURL/reports";
  static const String reportBorrows = "$reports/borrows";
  static const String reportBooks = "$reports/books";
  static const String reportUsers = "$reports/users";

  // Notifications
  static const String notifications = "$baseURL/notifications";
  static const String notificationsUnread = "$notifications/unread";
  static const String notificationsMarkRead = "$notifications/mark-read";
  static String notificationDetail(int id) => "$notifications/$id";

  // Settings
  static const String settings = "$baseURL/settings";
  static const String settingsProfile = "$settings/profile";
  static const String settingsPassword = "$settings/password";
  static const String settingsNotifications = "$settings/notifications";
}
