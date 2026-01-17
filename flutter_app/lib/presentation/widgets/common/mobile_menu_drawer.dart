import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';

class MobileMenuDrawer extends ConsumerStatefulWidget {
  const MobileMenuDrawer({super.key});

  @override
  ConsumerState<MobileMenuDrawer> createState() => _MobileMenuDrawerState();
}

class _MobileMenuDrawerState extends ConsumerState<MobileMenuDrawer> {
  String? _openCategory;

  // Language options (matches React)
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
  ];
  String _selectedLanguage = 'en';

  // Handle logout (matches React handleLogout)
  Future<void> _handleLogout() async {
    try {
      await ref.read(authProvider.notifier).logout();
      Fluttertoast.showToast(
        msg: 'Logout Successful',
        backgroundColor: Colors.green,
      );
      if (mounted) {
        Navigator.pop(context); // Close drawer
        context.go('/login');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
      );
    }
  }

  // Handle language change (matches React handleLanguageChange)
  void _handleLanguageChange(String? languageCode) {
    if (languageCode == null) return;

    setState(() => _selectedLanguage = languageCode);

    // TODO: Implement language change logic
    Fluttertoast.showToast(
      msg: 'Language changed to: $languageCode',
      backgroundColor: Colors.green,
    );

    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.currentUser;

    return Drawer(
      width: 288, // matches React w-72 (72 * 4 = 288px)
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 36,
                    errorBuilder: (context, error, stack) => Container(
                      height: 36,
                      width: 100,
                      color: Colors.grey[300],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Menu Content
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Shorts Link (Hidden on desktop in React, but shown here)
                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: const Text(
                      'Shorts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward, size: 22),
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/shorts');
                    },
                  ),

                  const Divider(height: 24),

                  // Categories with Subcategories
                  ...AppConstants.newsCategories.map((category) {
                    final isOpen = _openCategory == category;
                    final subcategories = _getSubcategories(category);

                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Icon(
                            isOpen ? Icons.expand_less : Icons.expand_more,
                            size: 20,
                          ),
                          onTap: () {
                            setState(() {
                              _openCategory = isOpen ? null : category;
                            });
                          },
                        ),

                        // Subcategories
                        if (isOpen)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24, bottom: 12),
                            child: Column(
                              children: subcategories.map((sub) {
                                return ListTile(
                                  title: Text(
                                    sub,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.go(
                                        '/category/${category.toLowerCase()}/${sub.toLowerCase()}');
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Language Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Language:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF40607),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedLanguage,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            items: _languages.map((lang) {
                              return DropdownMenuItem<String>(
                                value: lang['code'],
                                child: Text(lang['name']!),
                              );
                            }).toList(),
                            onChanged: _handleLanguageChange,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Login / Logout
                  if (currentUser != null)
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: _handleLogout,
                    )
                  else
                    ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/login');
                      },
                    ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Text(
                '© ${DateTime.now().year} The Eminent News',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get subcategories for a category (matches React subCategoriesMap)
  List<String> _getSubcategories(String category) {
    // TODO: Replace with your actual subcategory mapping
    final subcategoriesMap = {
      'National': ['Politics', 'Economy', 'Society'],
      'World': ['Americas', 'Europe', 'Asia', 'Africa'],
      'Business': ['Markets', 'Startups', 'Tech'],
      'Technology': ['AI', 'Mobile', 'Web'],
      'Sports': ['Cricket', 'Football', 'Tennis'],
      'Entertainment': ['Movies', 'Music', 'TV'],
      'Science': ['Space', 'Health', 'Environment'],
      'Health': ['Wellness', 'Fitness', 'Nutrition'],
    };

    return subcategoriesMap[category] ?? [];
  }
}
