class ApiConstants {
  // Auth endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String me = '/me';
  static const String updateProfile = '/me/update';
  static const String updatePassword = '/password/update';
  
  // News endpoints
  static const String news = '/news';
  static String newsDetail(String id) => '/news/$id';
  static String newsLike(String id) => '/news/$id/like';
  static String newsComment(String id) => '/news/$id/comment';
  static String deleteNews(String id) => '/news/$id';
  static String editorNews(String editorId) => '/editor/news/$editorId';
  
  // Shorts endpoints
  static const String shorts = '/shorts';
  static String deleteShort(String id) => '/shorts/$id';
  static const String myShorts = '/my-shorts';
  
  // Ads endpoints
  static const String ads = '/ads';
  static String deleteAds(String id) => '/ads/$id';
  
  // User/Editor endpoints
  static String followUser(String id) => '/user/$id/follow';
  static const String adminUsers = '/admin/users';
  static const String adminEditors = '/admin/editors';
  static String adminUser(String id) => '/admin/user/$id';
}
