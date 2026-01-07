import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../core/constants/app_constants.dart';
import 'providers.dart';

// Auth state
class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final userJson = SharedPrefsHelper.getObject(AppConstants.keyUser);
      final isAuth = SharedPrefsHelper.getBool(AppConstants.keyIsAuthenticated) ?? false;

      if (userJson != null && isAuth) {
        state = state.copyWith(
          user: UserModel.fromJson(userJson),
          isAuthenticated: true,
        );
      }
    } catch (e) {
      // Failed to load user from prefs
      state = state.copyWith(isAuthenticated: false);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.login(email: email, password: password);

      if (result['success'] == true) {
        final user = result['user'] as UserModel?;
        if (user != null) {
          // Save to shared preferences
          await SharedPrefsHelper.setObject(AppConstants.keyUser, user.toJson());
          await SharedPrefsHelper.setBool(AppConstants.keyIsAuthenticated, true);
          if (result['token'] != null) {
            await SharedPrefsHelper.setString(AppConstants.keyToken, result['token']);
          }

          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
          return true;
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: result['message'] ?? 'Login failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
      return false;
    }
  }

  Future<bool> signup({
    required String name,
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.signup(
        name: name,
        username: username,
        email: email,
        password: password,
        role: role,
      );

      if (result['success'] == true) {
        final user = result['user'] as UserModel?;
        if (user != null) {
          // Save to shared preferences
          await SharedPrefsHelper.setObject(AppConstants.keyUser, user.toJson());
          await SharedPrefsHelper.setBool(AppConstants.keyIsAuthenticated, true);
          if (result['token'] != null) {
            await SharedPrefsHelper.setString(AppConstants.keyToken, result['token']);
          }

          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
          return true;
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: result['message'] ?? 'Signup failed',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      
      // Clear shared preferences
      await SharedPrefsHelper.remove(AppConstants.keyUser);
      await SharedPrefsHelper.remove(AppConstants.keyToken);
      await SharedPrefsHelper.setBool(AppConstants.keyIsAuthenticated, false);

      state = AuthState(); // Reset to initial state
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshUser() async {
    try {
      final result = await _authService.getUserDetails();
      if (result['success'] == true) {
        final user = result['user'] as UserModel?;
        if (user != null) {
          await SharedPrefsHelper.setObject(AppConstants.keyUser, user.toJson());
          state = state.copyWith(user: user);
        }
      }
    } catch (e) {
      // Failed to refresh user
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
