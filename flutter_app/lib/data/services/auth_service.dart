import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  // Login - matches React:  POST /login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error occurred',
      );
    }
  }

  // Signup - matches React: POST /signup
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    String? dob,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.signup,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          if (dob != null) 'dob': dob,
        },
      );

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception(response.data['message'] ?? 'Signup failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error occurred',
      );
    }
  }

  // Logout - matches React: GET /logout
  Future<void> logout() async {
    try {
      final response = await _apiService.get(ApiConstants.logout);

      if (response.data['success'] == false) {
        throw Exception(response.data['message'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Network error occurred',
      );
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthService(apiService);
});
