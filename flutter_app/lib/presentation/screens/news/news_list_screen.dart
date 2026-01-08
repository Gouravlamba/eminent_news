import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/news_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/news/post_card.dart';

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(newsProvider.notifier).fetchNews());
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);

    if (newsState.isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(newsProvider.notifier).fetchNews(),
        child: newsState.news.isEmpty
            ? const Center(
                child: Text(
                  'No news posts found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: newsState.news.length,
                itemBuilder: (context, index) {
                  return PostCard(news: newsState.news[index]);
                },
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/news');
              break;
            case 2:
              context.go('/shorts');
              break;
            case 3:
              context.go('/my-profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), label: 'Shorts'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
