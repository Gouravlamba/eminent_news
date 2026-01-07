import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/news_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/news_service.dart';

// Service provider
final newsServiceProvider = Provider<NewsService>(
  (ref) => NewsService(ref.read(apiServiceProvider)),
);

// News state
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
      error: error ?? this.error,
    );
  }
}

// News provider
class NewsNotifier extends StateNotifier<NewsState> {
  final NewsService _newsService;

  NewsNotifier(this._newsService) : super(NewsState());

  Future<void> fetchNews({String? category}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _newsService.fetchNews(category: category);

      if (result['success'] == true) {
        state = state.copyWith(
          news: result['news'] as List<NewsModel>,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Failed to fetch news',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
    }
  }

  Future<NewsModel?> fetchNewsById(String id) async {
    try {
      final result = await _newsService.fetchNewsById(id);

      if (result['success'] == true) {
        return result['news'] as NewsModel?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> toggleLike(String newsId) async {
    try {
      final result = await _newsService.toggleLike(newsId);
      if (result['success'] == true) {
        // Refresh the news list
        await fetchNews();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addComment(String newsId, String comment) async {
    try {
      final result = await _newsService.addComment(newsId, comment);
      return result['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNews(String newsId) async {
    try {
      final result = await _newsService.deleteNews(newsId);
      if (result['success'] == true) {
        // Remove from local state
        state = state.copyWith(
          news: state.news.where((n) => n.id != newsId).toList(),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  return NewsNotifier(ref.read(newsServiceProvider));
});

// Single news detail provider
final newsDetailProvider = FutureProvider.family<NewsModel?, String>((ref, id) async {
  final newsService = ref.read(newsServiceProvider);
  final result = await newsService.fetchNewsById(id);
  
  if (result['success'] == true) {
    return result['news'] as NewsModel?;
  }
  return null;
});

// Import for apiServiceProvider
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
