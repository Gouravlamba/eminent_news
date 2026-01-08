import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/landing/landing_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/news/news_list_screen.dart';
import '../presentation/screens/news/news_detail_screen.dart';
import '../presentation/screens/shorts/shorts_reel_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/admin/admin_dashboard.dart';
import '../presentation/screens/admin/all_editors_screen.dart';
import '../presentation/screens/admin/all_users_screen.dart';
import '../presentation/screens/admin/shorts_manager.dart';
import '../presentation/screens/admin/ads_page.dart';
import '../presentation/screens/editor/editor_dashboard.dart';
import '../presentation/screens/editor/editor_shorts.dart';
import '../presentation/screens/not_found/not_found_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final currentUser = authState.currentUser;
      final path = state.uri.path;

      // Public routes
      if (path == '/' || path == '/login' || path.startsWith('/signup')) {
        return null;
      }

      // Admin routes
      if (path.startsWith('/admin')) {
        if (!isAuthenticated || currentUser?.role != 'admin') {
          return '/login';
        }
        return null;
      }

      // Editor routes
      if (path.startsWith('/editor')) {
        if (!isAuthenticated || currentUser?.role != 'editor') {
          return '/login';
        }
        return null;
      }

      // Private routes
      if (path == '/my-profile') {
        if (!isAuthenticated) {
          return '/login';
        }
        return null;
      }

      return null;
    },
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      // Public Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup/: role',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'user';
          return SignupScreen(role: role);
        },
      ),

      // Main App Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/news',
        builder: (context, state) => const NewsListScreen(),
      ),
      GoRoute(
        path: '/news/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return NewsDetailScreen(newsId: id);
        },
      ),
      GoRoute(
        path: '/shorts',
        builder: (context, state) => const ShortsReelScreen(),
      ),
      GoRoute(
        path: '/my-profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin/news',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/admin/editors',
        builder: (context, state) => const AllEditorsScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const AllUsersScreen(),
      ),
      GoRoute(
        path: '/admin/shorts',
        builder: (context, state) => const ShortsManager(),
      ),
      GoRoute(
        path: '/admin/ads',
        builder: (context, state) => const AdsPage(),
      ),

      // Editor Routes
      GoRoute(
        path: '/editor/news',
        builder: (context, state) => const EditorDashboard(),
      ),
      GoRoute(
        path: '/editor/shorts',
        builder: (context, state) => const EditorShorts(),
      ),
    ],
  );
});
