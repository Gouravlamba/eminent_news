import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';

// Auth State - matches React Redux authSlice
class AuthState {
  final UserModel? currentUser;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  AuthState({
    this.currentUser,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? currentUser,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
    );
  }
}

// Auth Notifier - matches React Redux actions
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final SharedPreferences _prefs;

  AuthNotifier(this._authService, this._prefs) : super(AuthState()) {
    _loadUser();
  }

  // Load user from local storage on init (matches redux-persist)
  Future<void> _loadUser() async {
    final userJson = _prefs.getString('currentUser');
    if (userJson != null) {
      try {
        final user = UserModel.fromJson(json.decode(userJson));
        state = state.copyWith(
          currentUser: user,
          isAuthenticated: true,
        );
      } catch (e) {
        await _prefs.remove('currentUser');
      }
    }
  }

  // Save user to local storage
  Future<void> _saveUser(UserModel user) async {
    await _prefs.setString('currentUser', json.encode(user.toJson()));
  }

  // Clear user from local storage
  Future<void> _clearUser() async {
    await _prefs.remove('currentUser');
  }

  // Login - matches React signInStart/signInSuccess/signInFailure
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );

      await _saveUser(user);

      state = state.copyWith(
        currentUser: user,
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception:  ', ''),
      );
      rethrow;
    }
  }

  // Signup
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    String? dob,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.signup(
        name: name,
        email: email,
        password: password,
        role: role,
        dob: dob,
      );

      await _saveUser(user);

      state = state.copyWith(
        currentUser: user,
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  // Logout - matches React signOutStart/signOutSuccess/signOutFailure
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      await _clearUser();

      state = AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

// Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // This will be overridden in main.dart
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final prefs = ref.watch(sharedPreferencesProvider);

  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }

  return AuthNotifier(authService, prefs);
});
