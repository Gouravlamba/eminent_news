import 'package:eminent_news_flutter/data/models/ads_model.dart';
import 'package:eminent_news_flutter/presentation/widgets/common/footer_widget.dart';
import 'package:eminent_news_flutter/presentation/widgets/news/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/news_provider.dart';
import '../../providers/ads_provider.dart';
import '../../widgets/common/loading_widget.dart';

import '../../widgets/news/post_card_small.dart';
import '../../widgets/common/faq_widget.dart';
import 'widgets/hero_carousel.dart';
import '../../../data/models/news_model.dart';

import '../../../core/constants/app_constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBottomNavIndex = 0;

  // Featured news (static like React)
  final Map<String, dynamic> featured = {
    '_id': 'ddlkfj',
    'title': 'Startup Revolutionises Last-Mile Delivery',
    'description':
        'A local startup has piloted an autonomous delivery network that reduces delivery times and cuts carbon emissions in dense cities.',
    'author': 'Rahul Desai',
    'date': 'November 9, 2025',
    'images': 'assets/images/w1.jpeg', // Add this image to assets
    'likes': 33,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.newsCategories.length,
      vsync: this,
    );

    // Fetch data on init (matches React useEffect)
    Future.microtask(() {
      ref.read(newsProvider.notifier).fetchNews();
      ref.read(adsProvider.notifier).fetchAds();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Get highlight ad by position (matches React logic)
  AdsModel? _getHighlightAd(List<AdsModel> highlightAds, int position) {
    if (highlightAds.isEmpty) return null;
    return highlightAds[position % highlightAds.length];
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    final adsState = ref.watch(adsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    // Loading state (matches React loading check)
    if (newsState.isLoading || adsState.isLoading) {
      return const Scaffold(
        body: LoadingWidget(),
      );
    }

    // Filter ads by category (matches React filter logic)
    final bannerAds =
        adsState.ads.where((ad) => ad.category == 'Banner').toList();
    final highlightAds =
        adsState.ads.where((ad) => ad.category == 'Highlights').toList();

    // Group news by category (matches React groupedNews)
    final groupedNews = {
      'national':
          newsState.news.where((n) => n.category == 'National').toList(),
      'world': newsState.news.where((n) => n.category == 'World').toList(),
      'trending':
          newsState.news.where((n) => n.category == 'Trending').toList(),
      'sports': newsState.news.where((n) => n.category == 'Sports').toList(),
    };

    // Sort news by date (for Today's Highlights)
    final sortedNews = [...newsState.news]..sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt) ?? DateTime.now();
        final dateB = DateTime.tryParse(b.createdAt) ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo-white.png',
              height: 30,
            ),

            // Space
            const SizedBox(width: 8),

            // Vertical Divider ( | )
            Container(
              height: 30,
              width: 1,
              color: Colors.white, // change color if needed
            ),

            // Space
            const SizedBox(width: 8),

            // Texts
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'The Eminent News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Empowering Wisdom',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => context.go('/my-profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(newsProvider.notifier).fetchNews();
          await ref.read(adsProvider.notifier).fetchAds();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Carousel (matches React HeroCarousel)
              if (bannerAds.isNotEmpty) HeroCarousel(ads: bannerAds),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: isMobile ? 16 : 8,
                ),
                child: Column(
                  children: [
                    // MOBILE:  Tabbed News Section
                    if (isMobile) _buildMobileTabs(groupedNews),

                    // DESKTOP: Two Column Layout
                    if (!isMobile)
                      _buildDesktopLayout(
                        sortedNews,
                        groupedNews,
                        highlightAds,
                      ),

                    // FAQ Section
                    const SizedBox(height: 32),
                    const FAQWidget(),
                    const SizedBox(height: 5),
                    const FooterWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedBottomNavIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          setState(() => _selectedBottomNavIndex = index);
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

  // MOBILE TABS (matches React mobile tabbed section)
  Widget _buildMobileTabs(Map<String, List<NewsModel>> groupedNews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore Categories',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Tab Bar
        Container(
          height: 48,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFF40607), width: 2),
              bottom: BorderSide(color: Color(0xFFF40607), width: 2),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[700],
            indicator: const BoxDecoration(
              color: Color(0xFFF40607),
            ),
            tabs: AppConstants.newsCategories
                .map((cat) => Tab(text: cat))
                .toList(),
          ),
        ),

        // Tab Views
        SizedBox(
          height: 600,
          child: TabBarView(
            controller: _tabController,
            children: AppConstants.newsCategories.map((category) {
              final key = category.toLowerCase();
              final newsList = groupedNews[key] ?? [];

              return newsList.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'No posts found for this category.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(top: 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return PostCard(
                          news: newsList[index],
                          fetchNews: () =>
                              ref.read(newsProvider.notifier).fetchNews(),
                        );
                      },
                    );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // DESKTOP LAYOUT (matches React desktop two-column layout)
  Widget _buildDesktopLayout(
    List<NewsModel> sortedNews,
    Map<String, List<NewsModel>> groupedNews,
    List<AdsModel> highlightAds,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT COLUMN: Today's Highlights (70%)
        Expanded(
          flex: 7,
          child: Container(
            margin: const EdgeInsets.only(top: 32, right: 40),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Header Badge
                Positioned(
                  top: -24,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF40607),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.emoji_events, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Today's Highlights",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // News List with Ads
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      ...sortedNews.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return Column(
                          children: [
                            PostCardSmall(
                              news: item,
                              fetchNews: () =>
                                  ref.read(newsProvider.notifier).fetchNews(),
                            ),
                            const Divider(),

                            // Insert ad after 5th and 10th item
                            if ((index == 4 || index == 9) &&
                                highlightAds.isNotEmpty)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 24),
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  _getHighlightAd(highlightAds, index)!
                                      .images[0],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) =>
                                      Container(color: Colors.grey[300]),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // RIGHT COLUMN: Latest News (30%)
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(top: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Header Badge
                Positioned(
                  top: -24,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF40607),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: const [
                        Text('⚡', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 4),
                        Text(
                          'Latest News',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Column(
                  children: [
                    const SizedBox(height: 16),

                    // Featured News Card
                    Container(
                      height: 192,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            featured['images'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                Container(color: Colors.grey[300]),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  featured['date'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  featured['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Small News List
                    ...groupedNews['national']!.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 28),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                item.images.isNotEmpty ? item.images[0] : '',
                                width: 112,
                                height: 112,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) =>
                                    Container(
                                  width: 112,
                                  height: 112,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'By ${item.editor?.name ?? "Unknown"} / ${_formatDate(item.createdAt)}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: const TextStyle(fontSize: 10),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () => context.go('/news/${item.id}'),
                                    child: const Text(
                                      'Read more →',
                                      style: TextStyle(
                                        color: Color(0xFFF40607),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateStr.split('T')[0];
    }
  }
}
