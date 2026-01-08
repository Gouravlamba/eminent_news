import 'package:dio/dio.dart';
import 'package:eminent_news_flutter/data/models/ads_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';

import 'api_service.dart';

class AdsService {
  final ApiService _apiService;

  AdsService(this._apiService);

  // Fetch all ads - matches React: GET /ads
  Future<List<AdsModel>> fetchAds() async {
    try {
      final response = await _apiService.get(ApiConstants.ads);

      if (response.data['success'] == true || response.data['ads'] != null) {
        final List adsList =
            response.data['ads'] ?? response.data['data'] ?? [];
        return adsList.map((json) => AdsModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch ads',
      );
    }
  }
}

final adsServiceProvider = Provider<AdsService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AdsService(apiService);
});
