import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/news_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/mobile_menu_drawer.dart';
import '../../widgets/common/footer_widget.dart';
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

  // Responsive breakpoints
  bool _isMobile(double width) => width < 600;
  bool _isTablet(double width) => width >= 600 && width < 900;
  bool _isDesktop(double width) => width >= 900 && width < 1200;
  bool _isLargeDesktop(double width) => width >= 1200;

  // Get number of columns based on screen width
  int _getCrossAxisCount(double width) {
    if (_isMobile(width)) return 1; // Mobile: 1 column
    if (_isTablet(width)) return 2; // Tablet: 2 columns
    if (_isDesktop(width)) return 3; // Desktop: 3 columns
    return 4; // Large Desktop: 4 columns
  }

  // Get responsive padding
  double _getHorizontalPadding(double width) {
    if (_isMobile(width)) return 16;
    if (_isTablet(width)) return 24;
    if (_isDesktop(width)) return 32;
    return 48;
  }

  // Get card spacing
  double _getCardSpacing(double width) {
    if (_isMobile(width)) return 16;
    if (_isTablet(width)) return 20;
    return 24;
  }

  // Get child aspect ratio
  double _getChildAspectRatio(double width) {
    if (_isMobile(width)) return 1.1; // Taller cards on mobile
    if (_isTablet(width)) return 0.95;
    if (_isDesktop(width)) return 0.9;
    return 0.85; // Compact cards on large screens
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = _isMobile(screenWidth);

    if (newsState.isLoading) {
      return const Scaffold(
        appBar: AppHeader(),
        drawer: MobileMenuDrawer(),
        body: LoadingWidget(),
      );
    }

    return Scaffold(
      appBar: const AppHeader(),
      drawer: const MobileMenuDrawer(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(newsProvider.notifier).fetchNews(),
        child: newsState.news.isEmpty
            ? _buildEmptyState(screenWidth)
            : _buildNewsList(screenWidth, newsState.news),
      ),
    );
  }

  // Empty state
  Widget _buildEmptyState(double screenWidth) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(screenWidth),
              vertical: 16,
            ),
            child: const Text(
              'All News',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No news posts found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // News list with responsive grid
  Widget _buildNewsList(double screenWidth, List news) {
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    final horizontalPadding = _getHorizontalPadding(screenWidth);
    final cardSpacing = _getCardSpacing(screenWidth);
    final childAspectRatio = _getChildAspectRatio(screenWidth);
    final isMobile = _isMobile(screenWidth);

    return CustomScrollView(
      slivers: [
        // Title Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              isMobile ? 16 : 24,
              horizontalPadding,
              isMobile ? 8 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All News',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // News count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF40607),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${news.length} Posts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Responsive Grid
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: cardSpacing,
              mainAxisSpacing: cardSpacing,
              childAspectRatio: 1.25,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PostCard(
                  news: news[index],
                  fetchNews: () => ref.read(newsProvider.notifier).fetchNews(),
                );
              },
              childCount: news.length,
            ),
          ),
        ),

        // Spacing before footer
        SliverToBoxAdapter(
          child: SizedBox(height: isMobile ? 32 : 48),
        ),

        // Footer
        const SliverToBoxAdapter(
          child: FooterWidget(),
        ),
      ],
    );
  }
}
