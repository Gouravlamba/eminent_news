import 'package:dio/dio.dart';
import '../models/news_model.dart';
import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class NewsService {
  final ApiService _apiService;

  NewsService(this._apiService);

  Future<Map<String, dynamic>> fetchNews({String? category}) async {
    try {
      final response = await _apiService.get(
        ApiConstants.news,
        queryParameters: category != null ? {'category': category} : null,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newsList = (data['news'] as List<dynamic>?)
                ?.map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        return {
          'success': data['success'] ?? true,
          'news': newsList,
        };
      } else {
        return {
          'success': false,
          'news': <NewsModel>[],
          'message': response.data['message'] ?? 'Failed to fetch news',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'news': <NewsModel>[],
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'news': <NewsModel>[],
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> fetchNewsById(String id) async {
    try {
      final response = await _apiService.get(ApiConstants.newsDetail(id));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': data['success'] ?? true,
          'news': data['news'] != null ? NewsModel.fromJson(data['news']) : null,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to fetch news',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> toggleLike(String newsId) async {
    try {
      final response = await _apiService.put(ApiConstants.newsLike(newsId));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': data['success'] ?? true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to toggle like',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> addComment(String newsId, String comment) async {
    try {
      final response = await _apiService.post(
        ApiConstants.newsComment(newsId),
        data: {'comment': comment},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': data['success'] ?? true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to add comment',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> deleteNews(String newsId) async {
    try {
      final response = await _apiService.delete(ApiConstants.deleteNews(newsId));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': data['success'] ?? true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to delete news',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> fetchEditorNews(String editorId) async {
    try {
      final response = await _apiService.get(ApiConstants.editorNews(editorId));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final newsList = (data['news'] as List<dynamic>?)
                ?.map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        return {
          'success': data['success'] ?? true,
          'news': newsList,
        };
      } else {
        return {
          'success': false,
          'news': <NewsModel>[],
          'message': response.data['message'] ?? 'Failed to fetch editor news',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'news': <NewsModel>[],
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'news': <NewsModel>[],
        'message': 'An unexpected error occurred',
      };
    }
  }
}
