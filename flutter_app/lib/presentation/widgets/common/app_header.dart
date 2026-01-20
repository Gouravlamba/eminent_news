import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/news_provider.dart';

class AppHeader extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  ConsumerState<AppHeader> createState() => _AppHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppHeaderState extends ConsumerState<AppHeader> {
  // Responsive breakpoints
  bool _isMobile(double width) => width < 600;
  bool _isTablet(double width) => width >= 600 && width < 1024;
  bool _isDesktop(double width) => width >= 1024;

  // Get responsive sizes
  double _getLogoHeight(double width) {
    if (_isMobile(width)) return 24;
    if (_isTablet(width)) return 28;
    return 32;
  }

  double _getTitleFontSize(double width) {
    if (_isMobile(width)) return 16;
    if (_isTablet(width)) return 18;
    return 20;
  }

  double _getSubtitleFontSize(double width) {
    if (_isMobile(width)) return 8;
    if (_isTablet(width)) return 9;
    return 10;
  }

  double _getIconSize(double width) {
    if (_isMobile(width)) return 24;
    if (_isTablet(width)) return 26;
    return 28;
  }

  double _getMenuIconSize(double width) {
    if (_isMobile(width)) return 28;
    if (_isTablet(width)) return 32;
    return 36;
  }

  double _getHorizontalPadding(double width) {
    if (_isMobile(width)) return 4;
    if (_isTablet(width)) return 8;
    return 16;
  }

  // Show search dialog
  void _showSearchDialog(BuildContext context, double screenWidth) {
    final isMobile = _isMobile(screenWidth);

    showDialog(
      context: context,
      builder: (context) => _SearchDialog(isMobile: isMobile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = _isMobile(screenWidth);
    final isTablet = _isTablet(screenWidth);
    final authState = ref.watch(authProvider);

    return AppBar(
      backgroundColor: const Color(0xFFF40607),
      elevation: 2,
      centerTitle: false,
      leadingWidth: isMobile ? 40 : (isTablet ? 56 : 64),
      leading: Builder(
        builder: (context) => IconButton(
          iconSize: 45,
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: _getMenuIconSize(screenWidth),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: 'Menu',
        ),
      ),
      title: _buildTitle(screenWidth, isMobile, isTablet),
      actions:
          _buildActions(screenWidth, isMobile, isTablet, context, authState),
    );
  }

  // Build responsive title
  Widget _buildTitle(double screenWidth, bool isMobile, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo-white.png',
          height: _getLogoHeight(screenWidth),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => Container(
            height: _getLogoHeight(screenWidth),
            width: isMobile ? 60 : 80,
            color: Colors.white24,
          ),
        ),
        SizedBox(width: isMobile ? 6 : 8),
        Container(
          height: isMobile ? 30 : (isTablet ? 34 : 37),
          width: isMobile ? 1.5 : 2,
          color: Colors.white,
        ),
        SizedBox(width: isMobile ? 6 : 8),
        if (screenWidth > 320)
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'The Eminent News',
                  style: TextStyle(
                    fontSize: _getTitleFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: isMobile ? 0 : 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (screenWidth > 360)
                  Text(
                    'Empowering Wisdom',
                    style: TextStyle(
                      fontSize: _getSubtitleFontSize(screenWidth),
                      color: Colors.white,
                      letterSpacing: isMobile ? 0 : 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  // Build responsive actions
  List<Widget> _buildActions(
    double screenWidth,
    bool isMobile,
    bool isTablet,
    BuildContext context,
    AuthState authState,
  ) {
    final iconSize = _getIconSize(screenWidth);
    final padding = _getHorizontalPadding(screenWidth);

    return [
      // Search Button
      IconButton(
        padding: EdgeInsets.symmetric(horizontal: padding),
        icon: Icon(Icons.search, color: Colors.white, size: iconSize),
        onPressed: () => _showSearchDialog(context, screenWidth),
        tooltip: 'Search',
      ),

      // Login Button OR Profile Icon
      if (authState.isAuthenticated)
        // Show Profile Icon when logged in
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: padding),
          icon: Icon(
            Icons.account_circle,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () => context.go('/my-profile'),
          tooltip: 'Profile',
        )
      else
        // Show Login Button when not logged in
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: TextButton(
            onPressed: () => context.go('/login'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white.withOpacity(1),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

      // Add spacing on desktop
      if (!isMobile) SizedBox(width: padding),
    ];
  }
}

// 🔍 SEARCH DIALOG
class _SearchDialog extends ConsumerStatefulWidget {
  final bool isMobile;

  const _SearchDialog({required this.isMobile});

  @override
  ConsumerState<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends ConsumerState<_SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Perform search
  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Get all news from provider
    final allNews = ref.read(newsProvider).news;

    // Filter news by title or description
    final results = allNews.where((news) {
      final titleMatch = news.title.toLowerCase().contains(query.toLowerCase());
      final descMatch =
          news.description.toLowerCase().contains(query.toLowerCase());
      return titleMatch || descMatch;
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: widget.isMobile ? screenWidth * 0.9 : 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          children: [
            // Header with search field
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF40607),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        hintText: 'Search news...',
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.7)),
                        border: InputBorder.none,
                      ),
                      onChanged: _performSearch,
                      onSubmitted: _performSearch,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search results
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchController.text.trim().isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.search, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Type to search news',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : _searchResults.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.info_outline,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'No results found',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: _searchResults.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                final news = _searchResults[index];
                                return ListTile(
                                  leading: news.images.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            news.images[0],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) =>
                                                    Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            ),
                                          ),
                                        )
                                      : null,
                                  title: Text(
                                    news.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    news.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.go('/news/${news.id}');
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
