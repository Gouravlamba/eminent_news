import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/news_model.dart';
import '../../data/services/news_service.dart';

// News State
class NewsState {
  final List<NewsModel> news;
  final bool isLoading;
  final String? error;

  NewsState({
    this.news = const [],
    this.isLoading = false,
    this.error,
  });

  NewsState copyWith({
    List<NewsModel>? news,
    bool? isLoading,
    String? error,
  }) {
    return NewsState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Filter news by category
  List<NewsModel> getByCategory(String category) {
    return news.where((n) => n.category == category).toList();
  }
}

// News Notifier
class NewsNotifier extends StateNotifier<NewsState> {
  final NewsService _newsService;

  NewsNotifier(this._newsService) : super(NewsState());

  // Fetch all news
  Future<void> fetchNews() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final news = await _newsService.fetchNews();
      state = state.copyWith(news: news, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Toggle like
  Future<void> toggleLike(String newsId) async {
    try {
      await _newsService.toggleLike(newsId);
      await fetchNews(); // Refresh news list
    } catch (e) {
      rethrow;
    }
  }

  // Delete news
  Future<void> deleteNews(String newsId) async {
    try {
      await _newsService.deleteNews(newsId);
      state = state.copyWith(
        news: state.news.where((n) => n.id != newsId).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

// Providers
final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  final newsService = ref.watch(newsServiceProvider);
  return NewsNotifier(newsService);
});

// Individual news detail provider
final newsDetailProvider = FutureProvider.family<NewsModel, String>(
  (ref, newsId) async {
    final newsService = ref.watch(newsServiceProvider);
    return await newsService.fetchNewsById(newsId);
  },
);
