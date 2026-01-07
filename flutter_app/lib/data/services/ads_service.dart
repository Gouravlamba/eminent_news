import 'package:dio/dio.dart';
import '../models/ads_model.dart';
import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class AdsService {
  final ApiService _apiService;

  AdsService(this._apiService);

  Future<Map<String, dynamic>> fetchAds({String? category}) async {
    try {
      final response = await _apiService.get(
        ApiConstants.ads,
        queryParameters: category != null ? {'category': category} : null,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final adsList = (data['ads'] as List<dynamic>?)
                ?.map((e) => AdsModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        return {
          'success': data['success'] ?? true,
          'ads': adsList,
        };
      } else {
        return {
          'success': false,
          'ads': <AdsModel>[],
          'message': response.data['message'] ?? 'Failed to fetch ads',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'ads': <AdsModel>[],
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'ads': <AdsModel>[],
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> deleteAds(String adsId) async {
    try {
      final response = await _apiService.delete(ApiConstants.deleteAds(adsId));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': data['success'] ?? true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to delete ad',
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
}
