import 'package:eminent_news_flutter/presentation/widgets/common/app_header.dart';
import 'package:eminent_news_flutter/presentation/widgets/common/mobile_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Format date (matches React formatDate)
  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('MMM yyyy').format(date);
    } catch (e) {
      return '-';
    }
  }

  // Handle Logout (matches React handleLogout)
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout? '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await ref.read(authProvider.notifier).logout();
        Fluttertoast.showToast(
          msg: 'Logout Successful',
          backgroundColor: Colors.green,
        );
        if (context.mounted) {
          context.go('/login');
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    // Fallback when no user (matches React fallback)
    if (user == null) {
      return Scaffold(
        appBar: const AppHeader(), // Use custom header
        drawer: const MobileMenuDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Please login to view your profile',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    final followersCount = user.followers.length;
    final followingCount = 0; // Add following to UserModel if needed

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFF40607),
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 24 : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER SECTION
              isMobile
                  ? _buildMobileHeader(
                      context, ref, user, followersCount, followingCount)
                  : _buildDesktopHeader(
                      context, ref, user, followersCount, followingCount),

              // BIO SECTION (Mobile)
              if (isMobile) ...[
                const SizedBox(height: 16),
                _buildBioSection(user, isMobile),
              ],

              // Mobile Sticky Action Buttons
              if (isMobile) const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      // Mobile Floating Action Buttons
      floatingActionButton: isMobile ? _buildMobileFloatingButtons() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Bottom nav comes from MainLayout automatically
    );
  }

  // MOBILE HEADER
  Widget _buildMobileHeader(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    int followersCount,
    int followingCount,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profile.webp',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.person, size: 56, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),

            // Name & Actions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: () => _handleLogout(context, ref),
                    icon: const Icon(Icons.logout, size: 16),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Stats
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              _buildStatItem('$followersCount', 'Followers'),
              const SizedBox(width: 48),
              _buildStatItem('$followingCount', 'Following'),
            ],
          ),
        ),
      ],
    );
  }

  // DESKTOP HEADER
  Widget _buildDesktopHeader(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    int followersCount,
    int followingCount,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Image
        Container(
          width: 144,
          height: 144,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.webp',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 72, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 32),

        // Info Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name & Actions
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: () => _handleLogout(context, ref),
                    icon: const Icon(Icons.logout, size: 16),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),

              // Stats
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    _buildStatItem('$followersCount', 'Followers'),
                    const SizedBox(width: 48),
                    _buildStatItem('$followingCount', 'Following'),
                  ],
                ),
              ),

              // Bio (Desktop)
              const SizedBox(height: 16),
              _buildBioSection(user, false),
            ],
          ),
        ),
      ],
    );
  }

  // STAT ITEM
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // BIO SECTION
  Widget _buildBioSection(dynamic user, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${user.name} • ${user.role}',
          style: TextStyle(
            fontSize: isMobile ? 16 : 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Joined ${_formatDate(user.dob)}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: isMobile ? 20 : 24),
        Text(
          'This is a short bio. Add your location, interests or a short description here.',
          style: TextStyle(
            fontSize: isMobile ? 14 : 15,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: isMobile ? 20 : 24),

        // Contact Info
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            if (user.email != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Earth',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // MOBILE FLOATING BUTTONS
  Widget _buildMobileFloatingButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            onPressed: () {
              Fluttertoast.showToast(msg: 'Edit Profile - Coming Soon');
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {
              Fluttertoast.showToast(msg: 'Settings - Coming Soon');
            },
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
