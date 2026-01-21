import 'package:eminent_news_flutter/data/models/ads_model.dart';
import 'package:eminent_news_flutter/presentation/widgets/common/app_header.dart';
import 'package:eminent_news_flutter/presentation/widgets/common/footer_widget.dart';
import 'package:eminent_news_flutter/presentation/widgets/common/mobile_menu_drawer.dart';

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

  final Map<String, dynamic> featured = {
    '_id': 'ddlkfj',
    'title': 'Startup Revolutionises Last-Mile Delivery',
    'description':
        'A local startup has piloted an autonomous delivery network that reduces delivery times and cuts carbon emissions in dense cities.',
    'author': 'Rahul Desai',
    'date': 'November 9, 2025',
    'images': 'assets/images/w1.jpeg',
    'likes': 33,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.newsCategories.length,
      vsync: this,
    );

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

  AdsModel? _getHighlightAd(List<AdsModel> highlightAds, int position) {
    if (highlightAds.isEmpty) return null;
    return highlightAds[position % highlightAds.length];
  }

  bool _isMobileOrTablet(double width) => width < 1024;

  // Mobile responsive helpers
  bool _isSmallPhone(double width) => width < 375;
  bool _isStandardPhone(double width) => width >= 375 && width < 414;
  bool _isLargePhone(double width) => width >= 414 && width < 768;

  double _getMobileHorizontalPadding(double width) {
    if (_isSmallPhone(width)) return 02;
    if (_isStandardPhone(width)) return 06;
    return 0;
  }

  double _getMobileCardSpacing(double width) {
    if (_isSmallPhone(width)) return 12;
    if (_isStandardPhone(width)) return 16;
    return 20;
  }

  double _getMobileChildAspectRatio(double width) {
    if (_isSmallPhone(width)) return 1.15;
    if (_isStandardPhone(width)) return 1.2;
    return 1.25;
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    final adsState = ref.watch(adsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (newsState.isLoading || adsState.isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    final bannerAds =
        adsState.ads.where((ad) => ad.category == 'Banner').toList();
    final highlightAds =
        adsState.ads.where((ad) => ad.category == 'Highlights').toList();

    final groupedNews = {
      'national':
          newsState.news.where((n) => n.category == 'National').toList(),
      'world': newsState.news.where((n) => n.category == 'World').toList(),
      'trending':
          newsState.news.where((n) => n.category == 'Trending').toList(),
      'sports': newsState.news.where((n) => n.category == 'Sports').toList(),
    };

    final sortedNews = [...newsState.news]..sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt) ?? DateTime.now();
        final dateB = DateTime.tryParse(b.createdAt) ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

    return Scaffold(
      appBar: const AppHeader(),
      drawer: const MobileMenuDrawer(),
      body: SafeArea(
        // ✅ Handles iOS notches and Android system bars
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(newsProvider.notifier).fetchNews();
            await ref.read(adsProvider.notifier).fetchAds();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeroCarousel(ads: bannerAds),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile
                        ? _getMobileHorizontalPadding(screenWidth)
                        : 20,
                    vertical: isMobile ? 16 : 8,
                  ),
                  child: Column(
                    children: [
                      if (isMobile) _buildMobileTabs(groupedNews, screenWidth),
                      if (!isMobile)
                        _buildDesktopLayout(
                            sortedNews, groupedNews, highlightAds),
                      const SizedBox(height: 32),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: const FAQWidget(),
                      )
                    ],
                  ),
                ),
                const FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // MOBILE TABS WITH RESPONSIVE CARDS
  Widget _buildMobileTabs(
      Map<String, List<NewsModel>> groupedNews, double screenWidth) {
    final horizontalPadding = _getMobileHorizontalPadding(screenWidth);
    final cardSpacing = _getMobileCardSpacing(screenWidth);
    final childAspectRatio = _getMobileChildAspectRatio(screenWidth);
    final titleFontSize = _isSmallPhone(screenWidth) ? 22.0 : 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Explore Categories',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Tab Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          height: _isSmallPhone(screenWidth) ? 44 : 48,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFF40607), width: 1.3),
              bottom: BorderSide(color: Color(0xFFF40607), width: 1.3),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[900],
            labelStyle: TextStyle(
              fontSize: _isSmallPhone(screenWidth) ? 14 : 16,
              fontWeight: FontWeight.w500,
            ),

            // ✅ ADD PADDING HERE
            indicatorPadding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 5,
            ),

            indicator: BoxDecoration(
              color: const Color(0xFFF40607),
              borderRadius: BorderRadius.circular(5),
            ),

            tabs: AppConstants.newsCategories
                .map(
                  (cat) => Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isSmallPhone(screenWidth) ? 12 : 16,
                      ),
                      child: Text(cat),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // Tab Views with Responsive Cards
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          height: 600,
          child: TabBarView(
            controller: _tabController,
            children: AppConstants.newsCategories.map((category) {
              final key = category.toLowerCase();
              final newsList = groupedNews[key] ?? [];

              return newsList.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.article_outlined,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              'No posts found for this category.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        top: cardSpacing,
                        bottom: cardSpacing,
                      ),
                      itemCount: newsList.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: cardSpacing),
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

  // DESKTOP LAYOUT (unchanged)
  Widget _buildDesktopLayout(
    List<NewsModel> sortedNews,
    Map<String, List<NewsModel>> groupedNews,
    List<AdsModel> highlightAds,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        Text("Today's Highlights",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
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
                                fetchNews: () => ref
                                    .read(newsProvider.notifier)
                                    .fetchNews()),
                            const Divider(),
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
                        Text('Latest News',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      height: 192,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(featured['images'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  Container(color: Colors.grey[300])),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7)
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(featured['date'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(featured['title'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    ...groupedNews['national']!.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 28),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                        color: Colors.grey[300]),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          height: 1.3),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(
                                      'By ${item.editor?.name ?? "Unknown"} / ${_formatDate(item.createdAt)}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600])),
                                  const SizedBox(height: 4),
                                  Text(item.description,
                                      style: const TextStyle(fontSize: 10),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () => context.go('/news/${item.id}'),
                                    child: const Text('Read more →',
                                        style: TextStyle(
                                            color: Color(0xFFF40607),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
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
