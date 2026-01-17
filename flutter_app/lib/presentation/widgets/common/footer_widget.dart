import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  static final List<Map<String, dynamic>> _socialLinks = [
    {'icon': FontAwesomeIcons.xTwitter, 'color': Colors.black},
    {'icon': FontAwesomeIcons.telegram, 'color': Color(0xFF0088CC)},
    {'icon': FontAwesomeIcons.whatsapp, 'color': Color(0xFF25D366)},
    {'icon': FontAwesomeIcons.linkedin, 'color': Color(0xFF0077B5)},
    {'icon': FontAwesomeIcons.facebook, 'color': Color(0xFF1877F2)},
    {'icon': FontAwesomeIcons.youtube, 'color': Color(0xFFFF0000)},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      color: Colors.black,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: 40,
      ),
      child: Column(
        children: [
          isMobile ? _mobileLayout() : _desktopLayout(),
          const SizedBox(height: 32),
          const Divider(color: Colors.white),
          const SizedBox(height: 12),
          const Text(
            'Powered by Kubza Pvt Ltd',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            '© ${DateTime.now().year} Eminentnews.com — All rights reserved',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// ---------------- DESKTOP ----------------
  Widget _desktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _aboutSection()),
        const SizedBox(width: 40),
        _socialCard(),
      ],
    );
  }

  /// ---------------- MOBILE ----------------
  Widget _mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _aboutSection(),
        const SizedBox(height: 24),
        _socialCard(),
      ],
    );
  }

  /// ---------------- ABOUT ----------------
  Widget _aboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _footerTitle(),
        const SizedBox(height: 24),
        const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 6),
        const Text(
          'Contact Us',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 6),
        const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 6),
        const Text(
          'Disclaimer',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 6),
        const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 6),
        const Text(
          'contact@eminentnews.com ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  /// ---------------- TITLE (LOGO + TEXT) ----------------
  Widget _footerTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo-white.png',
          height: 30,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Container(height: 37, width: 2, color: Colors.white),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The Eminent News',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Empowering Wisdom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ---------------- SOCIAL CARD ----------------
  Widget _socialCard() {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.rss_feed, color: Colors.white, size: 40),
              SizedBox(width: 12),
              Column(
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
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _socialLinks.map((s) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: s['color'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  s['icon'],
                  color: Colors.white,
                  size: 26,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
