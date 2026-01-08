import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  // Quick Links (matches React quickLinks)
  static const List<Map<String, String>> _quickLinks = [
    {'label': 'Home', 'to': '/home'},
    {'label': 'About Us', 'to': '/'},
    {'label': 'Contact Us', 'to': '#'},
    {'label': 'Disclaimer', 'to': '#'},
    {'label': 'Privacy Policy', 'to': '#'},
    {'label': 'Admin Login', 'to': '/admin/news'},
  ];

  // Social Links (matches React socialLinks)
  static final List<Map<String, dynamic>> _socialLinks = [
    {
      'icon': FontAwesomeIcons.xTwitter,
      'href': '#',
      'color': Colors.black,
    },
    {
      'icon': FontAwesomeIcons.telegram,
      'href': '#',
      'color': const Color(0xFF0088CC),
    },
    {
      'icon': FontAwesomeIcons.whatsapp,
      'href': '#',
      'color': const Color(0xFF25D366),
    },
    {
      'icon': FontAwesomeIcons.linkedin,
      'href': '#',
      'color': const Color(0xFF0077B5),
    },
    {
      'icon': FontAwesomeIcons.facebook,
      'href': '#',
      'color': const Color(0xFF1877F2),
    },
    {
      'icon': FontAwesomeIcons.youtube,
      'href': '#',
      'color': const Color(0xFFFF0000),
    },
  ];

  Future<void> _launchUrl(String url) async {
    if (url == '#') return;

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Column(
      children: [
        // SVG Wave (matches React SVG paths)
        if (!isMobile)
          // Desktop Wave
          CustomPaint(
            size: Size(screenWidth, 150),
            painter: _WavePainterDesktop(),
          )
        else
          // Mobile Wave
          CustomPaint(
            size: Size(screenWidth, 100),
            painter: _WavePainterMobile(),
          ),

        // Footer Content
        Container(
          color: Colors.black,
          child: Column(
            children: [
              // Main Footer Content
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 48,
                  vertical: isMobile ? 24 : 48,
                ),
                child: isMobile
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
              ),

              // Copyright Section
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.9),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '© ${DateTime.now().year} Eminentnews.com — All rights reserved',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // MOBILE LAYOUT
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAboutSection(),
        const SizedBox(height: 48),
        _buildCategoriesSection(),
        const SizedBox(height: 48),
        _buildQuickLinksSection(context),
        const SizedBox(height: 48),
        _buildSocialMediaSection(),
      ],
    );
  }

  // DESKTOP LAYOUT (4 columns)
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildAboutSection()),
        const SizedBox(width: 32),
        Expanded(child: _buildCategoriesSection()),
        const SizedBox(width: 32),
        Expanded(child: _buildQuickLinksSection(context)),
        const SizedBox(width: 32),
        Expanded(child: _buildSocialMediaSection()),
      ],
    );
  }

  // ABOUT SECTION
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Image.asset(
          'assets/images/logo-white.png',
          height: 48,
          errorBuilder: (context, error, stack) => Container(
            height: 48,
            width: 100,
            color: Colors.grey[800],
            child: const Icon(Icons.newspaper, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),

        // Description
        const Text(
          'The Eminent News (TEN) provides daily current affairs news for competitive exams like UPSC, State Services & many others where current affairs matter. Join us to learn, lead & succeed with quality content and better results.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        // Email
        const Text(
          'Email : contact@eminentnews.com',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // CATEGORIES SECTION
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...AppConstants.newsCategories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                // TODO: Navigate to category
              },
              child: Text(
                cat,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // QUICK LINKS SECTION
  Widget _buildQuickLinksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ..._quickLinks.map((link) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                if (link['to']! == '#') return;
                context.go(link['to']!);
              },
              child: Text(
                link['label']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  // SOCIAL MEDIA SECTION
  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Follow Us On',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Social Box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with RSS icon
              Row(
                children: const [
                  Icon(
                    Icons.rss_feed,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Follow Us On',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Get Latest Update On Social Media',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Social Icons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _socialLinks.map((social) {
                  return InkWell(
                    onTap: () => _launchUrl(social['href']),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: social['color'],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FaIcon(
                        social['icon'],
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Zoho Mail (if you have the asset)
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _launchUrl('#'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Image.asset(
                    'assets/images/zoho.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stack) => const Icon(
                      Icons.email,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// DESKTOP WAVE PAINTER (matches React SVG path)
class _WavePainterDesktop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start point
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.52);

    // Curve matching React SVG path
    path.cubicTo(
      size.width * 0.119,
      size.height * 0.61,
      size.width * 0.238,
      size.height * 0.70,
      size.width * 0.353,
      size.height * 0.686,
    );

    path.cubicTo(
      size.width * 0.467,
      size.height * 0.67,
      size.width * 0.577,
      size.height * 0.54,
      size.width * 0.685,
      size.height * 0.496,
    );

    path.cubicTo(
      size.width * 0.792,
      size.height * 0.45,
      size.width * 0.896,
      size.height * 0.48,
      size.width,
      size.height * 0.52,
    );

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// MOBILE WAVE PAINTER (matches React mobile SVG path)
class _WavePainterMobile extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.38);

    // Simplified wave for mobile
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.45,
      size.width * 0.5,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.65,
      size.width,
      size.height * 0.38,
    );

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
