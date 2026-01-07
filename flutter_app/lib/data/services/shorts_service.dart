import 'package:dio/dio.dart';
import '../models/shorts_model.dart';
import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class ShortsService {
  final ApiService _apiService;

  ShortsService(this._apiService);

  Future<Map<String, dynamic>> fetchShorts() async {
    try {
      final response = await _apiService.get(ApiConstants.shorts);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final shortsList = (data['shorts'] as List<dynamic>?)
                ?.map((e) => ShortModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        return {
          'success': data['success'] ?? true,
          'shorts': shortsList,
        };
      } else {
        return {
          'success': false,
          'shorts': <ShortModel>[],
          'message': response.data['message'] ?? 'Failed to fetch shorts',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'shorts': <ShortModel>[],
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'shorts': <ShortModel>[],
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> fetchMyShorts() async {
    try {
      final response = await _apiService.get(ApiConstants.myShorts);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final shortsList = (data['shorts'] as List<dynamic>?)
                ?.map((e) => ShortModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        return {
          'success': data['success'] ?? true,
          'shorts': shortsList,
        };
      } else {
        return {
          'success': false,
          'shorts': <ShortModel>[],
          'message': response.data['message'] ?? 'Failed to fetch shorts',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'shorts': <ShortModel>[],
        'message': e.response?.data['message'] ?? 'Network error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'shorts': <ShortModel>[],
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> likeShort(String shortId) async {
    try {
      final response = await _apiService.post('/shorts/$shortId/like');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': data['success'] ?? true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to like short',
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

  Future<Map<String, dynamic>> deleteShort(String shortId) async {
    try {
      final response = await _apiService.delete(ApiConstants.deleteShort(shortId));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': data['success'] ?? true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to delete short',
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
