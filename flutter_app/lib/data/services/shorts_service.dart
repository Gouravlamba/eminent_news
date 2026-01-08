import 'package:dio/dio.dart';
import 'package:eminent_news_flutter/core/constants/api_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shorts_model.dart';
import 'api_service.dart';

class ShortsService {
  final ApiService _apiService;

  ShortsService(this._apiService);

  // Fetch all shorts - matches React: GET /shorts
  Future<List<ShortModel>> fetchShorts() async {
    try {
      final response = await _apiService.get(ApiConstants.shorts);

      if (response.data['success'] == true || response.data['shorts'] != null) {
        final List shortsList = response.data['shorts'] ?? [];
        return shortsList.map((json) => ShortModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch shorts',
      );
    }
  }

  // Like short - matches React: POST /shorts/:id/like
  Future<void> likeShort(String shortId) async {
    try {
      await _apiService.post(ApiConstants.likeShorts(shortId));
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to like short',
      );
    }
  }
}

final shortsServiceProvider = Provider<ShortsService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ShortsService(apiService);
});
