import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';

class AdminSidebar extends ConsumerWidget {
  final bool isEditor;

  const AdminSidebar({super.key, this.isEditor = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      width: 250,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.newspaper, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                const Text(
                  'The Eminent News',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isEditor ? 'EDITOR PANEL' : 'ADMIN PANEL',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: isEditor
                  ? [
                      _buildMenuItem(
                        context,
                        icon: Icons.article,
                        title: 'My News',
                        route: '/editor/news',
                        isActive: currentRoute == '/editor/news',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.video_library,
                        title: 'My Shorts',
                        route: '/editor/shorts',
                        isActive: currentRoute == '/editor/shorts',
                      ),
                    ]
                  : [
                      _buildMenuItem(
                        context,
                        icon: Icons.dashboard,
                        title: 'News',
                        route: '/admin/news',
                        isActive: currentRoute == '/admin/news',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.people,
                        title: 'Editors',
                        route: '/admin/editors',
                        isActive: currentRoute == '/admin/editors',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.group,
                        title: 'Users',
                        route: '/admin/users',
                        isActive: currentRoute == '/admin/users',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.video_library,
                        title: 'Shorts',
                        route: '/admin/shorts',
                        isActive: currentRoute == '/admin/shorts',
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.ad_units,
                        title: 'Ads',
                        route: '/admin/ads',
                        isActive: currentRoute == '/admin/ads',
                      ),
                    ],
            ),
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () async {
                try {
                  await ref.read(authProvider.notifier).logout();
                  Fluttertoast.showToast(msg: 'Logout Successful');
                  if (context.mounted) {
                    context.go('/login');
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString().replaceAll('Exception: ', ''),
                    backgroundColor: Colors.red,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required bool isActive,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      selected: isActive,
      selectedTileColor: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () => context.go(route),
    );
  }
}
