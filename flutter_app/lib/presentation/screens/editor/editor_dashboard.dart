import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/news_provider.dart';
import '../../widgets/admin/admin_sidebar.dart';
import '../../widgets/common/loading_widget.dart';

class EditorDashboard extends ConsumerStatefulWidget {
  const EditorDashboard({super.key});

  @override
  ConsumerState<EditorDashboard> createState() => _EditorDashboardState();
}

class _EditorDashboardState extends ConsumerState<EditorDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(newsProvider.notifier).fetchNews());
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar (reusing admin sidebar with editor mode)
          const AdminSidebar(isEditor: true),

          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'My News Articles',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Add new news
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create News'),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: newsState.isLoading
                      ? const LoadingWidget()
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.article,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'My News Dashboard',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create and manage your news articles',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
