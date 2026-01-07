import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/splash/splash_screen.dart';
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

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final user = authState.user;
      final goingToLogin = state.matchedLocation == '/login';
      final goingToSignup = state.matchedLocation.startsWith('/signup');
      final goingToLanding = state.matchedLocation == '/';

      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && !goingToLogin && !goingToSignup && !goingToLanding) {
        // Allow access to public routes
        if (state.matchedLocation == '/home' ||
            state.matchedLocation == '/news' ||
            state.matchedLocation.startsWith('/news/') ||
            state.matchedLocation == '/shorts') {
          return null;
        }
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup/:role',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'user';
          return SignupScreen(role: role);
        },
      ),
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
          final id = state.pathParameters['id'] ?? '';
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
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated) {
            return '/login';
          }
          return null;
        },
      ),
      // Admin routes
      GoRoute(
        path: '/admin/news',
        builder: (context, state) => const AdminDashboard(),
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated || authState.user?.role != 'admin') {
            return '/';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/admin/editors',
        builder: (context, state) => const AllEditorsScreen(),
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated || authState.user?.role != 'admin') {
            return '/';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const AllUsersScreen(),
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated || authState.user?.role != 'admin') {
            return '/';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/admin/shorts',
        builder: (context, state) => const ShortsManager(),
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated || authState.user?.role != 'admin') {
            return '/';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/admin/ads',
        builder: (context, state) => const AdsPage(),
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated || authState.user?.role != 'admin') {
            return '/';
          }
          return null;
        },
      ),
      // Editor routes
      GoRoute(
        path: '/editor/news',
        builder: (context, state) => const EditorDashboard(),
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated || 
              (authState.user?.role != 'editor' && authState.user?.role != 'admin')) {
            return '/';
          }
          return null;
        },
      ),
      GoRoute(
        path: '/editor/shorts',
        builder: (context, state) => const EditorShorts(),
        redirect: (context, state) {
          final authState = ref.read(authProvider);
          if (!authState.isAuthenticated || 
              (authState.user?.role != 'editor' && authState.user?.role != 'admin')) {
            return '/';
          }
          return null;
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
});
