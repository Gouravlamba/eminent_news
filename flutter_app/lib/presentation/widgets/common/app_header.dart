import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'mobile_menu_drawer.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize {
    // Responsive height based on platform
    return const Size.fromHeight(kToolbarHeight);
  }

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = _isMobile(screenWidth);
    final isTablet = _isTablet(screenWidth);
    final isDesktop = _isDesktop(screenWidth);

    return AppBar(
      backgroundColor: const Color(0xFFF40607),
      elevation: 2,
      centerTitle: false,
      leadingWidth: isMobile ? 40 : (isTablet ? 56 : 64),
      leading: Builder(
        builder: (context) => IconButton(
          iconSize: 45,
          // padding: EdgeInsets.all(isMobile ? 8 : 12),
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
      actions: _buildActions(screenWidth, isMobile, isTablet, context),
    );
  }

  // Build responsive title
  Widget _buildTitle(double screenWidth, bool isMobile, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
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

        // Spacing
        SizedBox(width: isMobile ? 6 : 8),

        // Divider
        Container(
          height: isMobile ? 30 : (isTablet ? 34 : 37),
          width: isMobile ? 1.5 : 2,
          color: Colors.white,
        ),

        // Spacing
        SizedBox(width: isMobile ? 6 : 8),

        // Text (hide on very small screens)
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
                // Hide subtitle on very small screens
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
  ) {
    final iconSize = _getIconSize(screenWidth);
    final padding = _getHorizontalPadding(screenWidth);

    return [
      // Search Button
      IconButton(
        padding: EdgeInsets.symmetric(horizontal: padding),
        icon: Icon(Icons.search, color: Colors.white, size: iconSize),
        onPressed: () {
          // TODO: Implement search
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Search - Coming Soon'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        tooltip: 'Search',
      ),

      // Profile Button
      IconButton(
        padding: EdgeInsets.symmetric(horizontal: padding),
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
          size: iconSize,
        ),
        onPressed: () => context.go('/my-profile'),
        tooltip: 'Profile',
      ),

      // Add spacing on desktop
      if (!isMobile) SizedBox(width: padding),
    ];
  }
}
