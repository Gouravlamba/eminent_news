import 'package:dio/dio.dart';
import 'package:eminent_news_flutter/data/models/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';

import 'api_service.dart';

class NewsService {
  final ApiService _apiService;

  NewsService(this._apiService);

  // Fetch all news - matches React: GET /news
  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await _apiService.get(ApiConstants.news);

      if (response.data['success'] == true || response.data['news'] != null) {
        final List newsList =
            response.data['news'] ?? response.data['data'] ?? [];
        return newsList.map((json) => NewsModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch news',
      );
    }
  }

  // Fetch news by ID - matches React: GET /news/:id
  Future<NewsModel> fetchNewsById(String id) async {
    try {
      final response = await _apiService.get(ApiConstants.newsById(id));

      if (response.data['success'] == true || response.data['news'] != null) {
        return NewsModel.fromJson(
            response.data['news'] ?? response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'News not found');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch news details',
      );
    }
  }

  // Like/Unlike news - matches React: PUT /news/:id/like
  Future<Map<String, dynamic>> toggleLike(String newsId) async {
    try {
      final response = await _apiService.put(ApiConstants.likeNews(newsId));

      return {
        'success': true,
        'message': response.data['message'] ?? 'Success',
        'likesCount': response.data['likesCount'],
      };
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to toggle like',
      );
    }
  }

  // Follow/Unfollow editor - matches React: PUT /editors/:id/follow
  Future<Map<String, dynamic>> toggleFollow(String editorId) async {
    try {
      final response = await _apiService.put(
        ApiConstants.followEditor(editorId),
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Success',
      };
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to toggle follow',
      );
    }
  }

  // Delete news (Admin only) - matches React: DELETE /news/:id
  Future<void> deleteNews(String newsId) async {
    try {
      final response = await _apiService.delete(ApiConstants.newsById(newsId));

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to delete news');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to delete news',
      );
    }
  }

  // Add comment - matches React: POST /news/:id/comment
  Future<void> addComment(String newsId, String comment) async {
    try {
      final response = await _apiService.post(
        ApiConstants.commentNews(newsId),
        data: {'comment': comment},
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to add comment');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to add comment',
      );
    }
  }
}

final newsServiceProvider = Provider<NewsService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NewsService(apiService);
});
