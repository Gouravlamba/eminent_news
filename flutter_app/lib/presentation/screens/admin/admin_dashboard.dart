import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/news_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/admin/admin_sidebar.dart';
import '../../widgets/admin/admin_news_card.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(newsProvider.notifier).fetchNews());
  }

  Future<void> _handleDeleteNews(String newsId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete News'),
        content: const Text('Are you sure you want to delete this news item? '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(newsProvider.notifier).deleteNews(newsId);
        Fluttertoast.showToast(
          msg: 'News Deleted Successfully',
          backgroundColor: Colors.green,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const AdminSidebar(),

          // Main Content
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
                        'News Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Add new news
                          Fluttertoast.showToast(msg: 'Add News - Coming Soon');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add News'),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: newsState.isLoading
                      ? const LoadingWidget()
                      : newsState.news.isEmpty
                          ? const Center(child: Text('No news found'))
                          : RefreshIndicator(
                              onRefresh: () =>
                                  ref.read(newsProvider.notifier).fetchNews(),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(24),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: newsState.news.length,
                                itemBuilder: (context, index) {
                                  return AdminNewsCard(
                                    news: newsState.news[index],
                                    onDelete: () => _handleDeleteNews(
                                        newsState.news[index].id),
                                  );
                                },
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
