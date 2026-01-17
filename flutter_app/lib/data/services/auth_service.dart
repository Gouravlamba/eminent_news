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
        '/login',
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
    String? username,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _apiService.post(
        '/register',
        data: {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
          'role': role,
        },
      );

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw Exception(response.data['message'] ?? 'Signup failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Signup failed.  Please try again.',
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
