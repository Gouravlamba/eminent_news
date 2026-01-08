class ApiConstants {
  // Replace with your actual backend URL
  // This matches your VITE_BASE_URL from React
  static const String baseUrl =
      'http://172.11.10.244:5000/api/v1'; // Updated to use the machine's IP address

  // Auth Endpoints
  static const String login = '/login';
  static const String signup = '/signup';
  static const String logout = '/logout';

  // News Endpoints
  static const String news = '/news';
  static String newsById(String id) => '/news/$id';
  static String likeNews(String id) => '/news/$id/like';
  static String commentNews(String id) => '/news/$id/comment';

  // Shorts Endpoints
  static const String shorts = '/shorts';
  static String shortsById(String id) => '/shorts/$id';
  static String likeShorts(String id) => '/shorts/$id/like';

  // Ads Endpoints
  static const String ads = '/ads';

  // User Endpoints
  static const String profile = '/profile';
  static String followEditor(String id) => '/editors/$id/follow';

  // Admin Endpoints
  static const String allEditors = '/admin/editors';
  static const String allUsers = '/admin/users';
}
