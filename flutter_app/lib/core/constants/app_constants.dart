class AppConstants {
  static const String appName = 'The Eminent News';
  static const String appTagline = 'Empowering Wisdom';

  // News Categories (from React types/news. ts)
  static const List<String> newsCategories = [
    'National',
    'World',
    'Trending',
    'Sports',
    'Entertainment',
    'Exam Update',
  ];

  // Ads Categories
  static const List<String> adsCategories = [
    'Banner',
    'Highlights',
  ];

  // User Roles
  static const String roleUser = 'user';
  static const String roleEditor = 'editor';
  static const String roleAdmin = 'admin';

  // Sub Categories Map (from React types/news.ts)
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
      'Essays'
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
      'Environment'
    ],
    'Trending': [
      'Honors and Awards',
      'Books & Authors',
      'Brand Ambassadors',
      'Eminent',
      'Health & Disease',
      'Important Days and Themes',
      'GI Tags',
      'Fairs, Festivals & Exhibitions'
    ],
    'Sports': [
      'Indian Sports',
      'Team 11',
      'Athletic Events',
      'Olympic Games',
      'Sports Persons'
    ],
    'Entertainment': [
      'Automobiles',
      'Gadget',
      'Lovey Dovey',
      'Startups',
      'Travel'
    ],
    'Exam Update': [
      'Exam Notification',
      'Job Notification',
      'Q/A',
      'Magazines',
      'Podcast',
      'TEN updates'
    ],
  };
}
