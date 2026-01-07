class AppConstants {
  // News categories
  static const List<String> newsCategories = [
    'National',
    'World',
    'Trending',
    'Sports',
    'Entertainment',
    'Exam Update',
  ];

  // Subcategories map
  static const Map<String, List<String>> subCategoriesMap = {
    'National': [
      'Daily Short News',
      'State News',
      'Government Scheme',
      'Economy & Business',
      'Judicial News',
      'Social Justice',
      'Indian Society',
      'Internal Security',
      'Editorial',
      'Essays',
    ],
    'World': [
      'World News',
      'Bilateral Relations',
      'World Organizations',
      'World Indexes & Reports',
      'Conferences, meeting & Summits',
      'Space Technology',
      'Defense News',
      'Innovation & Technology',
      'Environment',
    ],
    'Trending': [
      'Honors and Awards',
      'Books & Authors',
      'Brand Ambassadors',
      'Eminent',
      'Health & Disease',
      'Important Days and Themes',
      'GI Tags',
      'Fairs, Festivals & Exhibitions',
    ],
    'Sports': [
      'Indian Sports',
      'Team 11',
      'Athelatic Events',
      'Olympic Games',
      'Sports Persons',
    ],
    'Entertainment': [
      'Automobiles',
      'Gadget',
      'Lovey Dovey',
      'Startups',
      'Travel',
    ],
    'Exam Update': [
      'Exam Notification',
      'Job Notification',
      'Q/A',
      'Magazines',
      'Podcast',
      'TEN updates',
    ],
  };

  // Ad categories
  static const List<String> adCategories = [
    'Banner',
    'Highlights',
  ];

  // User roles
  static const String roleUser = 'user';
  static const String roleEditor = 'editor';
  static const String roleAdmin = 'admin';

  // Shared preferences keys
  static const String keyUser = 'user';
  static const String keyToken = 'token';
  static const String keyIsAuthenticated = 'isAuthenticated';
}
