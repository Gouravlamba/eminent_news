import 'package:eminent_news_flutter/presentation/screens/splash/splash_screen.dart';
import 'package:eminent_news_flutter/presentation/screens/video/videos_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/layouts/main_layout.dart';
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
      // ========================================
      // PUBLIC ROUTES (NO BOTTOM NAV)
      // ========================================
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup/:role', // Fixed extra space in the route path
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'user';
          return SignupScreen(role: role);
        },
      ),

      // ========================================
      // MAIN APP ROUTES (WITH BOTTOM NAV)
      // ========================================
      ShellRoute(
        builder: (context, state, child) {
          // Determine current index based on location
          int currentIndex = 0;
          final path = state.uri.path;

          if (path == '/home') {
            currentIndex = 0;
          } else if (path.startsWith('/news')) {
            currentIndex = 1;
          } else if (path.startsWith('/shorts')) {
            currentIndex = 2;
          } else if (path.startsWith('/videos')) {
            currentIndex = 3;
          } else if (path.startsWith('/my-profile')) {
            currentIndex = 4;
          }

          return MainLayout(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          // Home
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const HomeScreen(),
            ),
          ),

          // News List
          GoRoute(
            path: '/news',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const NewsListScreen(),
            ),
          ),

          // News Detail
          GoRoute(
            path: '/news/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage(
                child: NewsDetailScreen(newsId: id),
              );
            },
          ),

          // Shorts
          GoRoute(
            path: '/shorts',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ShortsReelScreen(),
            ),
          ),
          //videos
          GoRoute(
            path: '/videos',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const VideosScreen(),
            ),
          ),

          // Profile
          GoRoute(
            path: '/my-profile',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),

      // ========================================
      // ADMIN ROUTES (NO BOTTOM NAV)
      // ========================================
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

      // ========================================
      // EDITOR ROUTES (NO BOTTOM NAV)
      // ========================================
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
