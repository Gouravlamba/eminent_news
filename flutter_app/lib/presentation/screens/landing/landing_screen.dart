import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../widgets/common/footer_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final List<double> _opacities = [1.0, 1.0, 1.0, 1.0];
  int _activeIndex = 0;

  void _updateOpacity(int index, double visibleFraction) {
    setState(() {
      _opacities[index] = (visibleFraction * 1.0).clamp(0.15, 1.0);
      if (visibleFraction > 0.5) {
        _activeIndex = index;
      }
    });
  }

  // Responsive breakpoints
  bool _isMobile(double width) => width < 640;
  bool _isTablet(double width) => width >= 640 && width < 1024;
  bool _isDesktop(double width) => width >= 1024;

  // Get responsive padding
  double _getHorizontalPadding(double width) {
    if (_isMobile(width)) return 16;
    if (_isTablet(width)) return 40;
    return 160;
  }

  // Get responsive font size
  double _getTitleFontSize(double width) {
    if (_isMobile(width)) return 28;
    if (_isTablet(width)) return 32;
    return 36;
  }

  double _getBodyFontSize(double width) {
    if (_isMobile(width)) return 14;
    if (_isTablet(width)) return 15;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavbar(context, screenWidth),
            _buildHeroSection(screenWidth),
            _buildSlider1(screenWidth),
            _buildSlider2(screenWidth),
            _buildSlider3(screenWidth),
            _buildFeaturedSection(screenWidth),
            _buildBusinessSection(screenWidth),
            _buildContactSection(screenWidth), // 🔥 CONTACT SECTION ADDED
            _buildDownloadSection(screenWidth),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  // RESPONSIVE NAVBAR
  Widget _buildNavbar(BuildContext context, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(screenWidth),
        vertical: _isMobile(screenWidth) ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            height: _isMobile(screenWidth) ? 24 : 32,
            errorBuilder: (context, error, stack) => Container(
              height: _isMobile(screenWidth) ? 24 : 32,
              width: _isMobile(screenWidth) ? 60 : 80,
              color: Colors.grey[300],
            ),
          ),
          InkWell(
            onTap: () => context.go('/home'),
            child: Text(
              'Read Now',
              style: TextStyle(
                color: Colors.grey,
                fontSize: _isMobile(screenWidth) ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // RESPONSIVE HERO SECTION
  Widget _buildHeroSection(double screenWidth) {
    final isMobile = _isMobile(screenWidth);
    final isTablet = _isTablet(screenWidth);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1400),
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(screenWidth),
        vertical: isMobile ? 40 : (isTablet ? 60 : 80),
      ),
      child: isMobile || isTablet
          ? Column(
              children: [
                Image.asset(
                  'assets/images/1st.png',
                  width: isMobile ? 200 : 280,
                  errorBuilder: (context, error, stack) => Container(
                    width: isMobile ? 200 : 280,
                    height: isMobile ? 320 : 400,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: isMobile ? 24 : 40),
                _buildHeroText(screenWidth),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/1st.png',
                    width: 280,
                    errorBuilder: (context, error, stack) => Container(
                      width: 280,
                      height: 450,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 60),
                Expanded(flex: 3, child: _buildHeroText(screenWidth)),
              ],
            ),
    );
  }

  Widget _buildHeroText(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: _getTitleFontSize(screenWidth),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.3,
            ),
            children: const [
              TextSpan(text: 'Learn, Leap and Lead in Life along with '),
              TextSpan(
                  text: 'The Eminent News',
                  style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        SizedBox(height: _isMobile(screenWidth) ? 12 : 16),
        Text(
          'We Provide almost 100% accurate news for everyone Especially'
          ' Youth Aspirants of world.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: _getBodyFontSize(screenWidth),
            height: 1.6,
          ),
        ),
        SizedBox(height: _isMobile(screenWidth) ? 24 : 32),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildStoreButton('assets/images/appStore.png', screenWidth),
            _buildStoreButton('assets/images/playStore.png', screenWidth),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreButton(String asset, double screenWidth) {
    return InkWell(
      onTap: () {},
      child: Image.asset(
        asset,
        height: _isMobile(screenWidth) ? 36 : 40,
        errorBuilder: (context, error, stack) => Container(
          height: _isMobile(screenWidth) ? 36 : 40,
          width: _isMobile(screenWidth) ? 100 : 120,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFFFCDD2), width: 1)),
      ),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 24,
            color: Color(0xFFF40607),
            fontWeight: FontWeight.w600),
      ),
    );
  }

  // RESPONSIVE SLIDER 1
  Widget _buildSlider1(double screenWidth) {
    return VisibilityDetector(
      key: const Key('slider-1'),
      onVisibilityChanged: (info) => _updateOpacity(0, info.visibleFraction),
      child: AnimatedOpacity(
        opacity: _opacities[0],
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: Transform.translate(
          offset: Offset(0, (1 - _opacities[0]) * 12),
          child: _buildSliderSection(
            screenWidth,
            'assets/images/2nd.png',
            _buildSlider1Text(screenWidth),
            imageLeft: false,
          ),
        ),
      ),
    );
  }

  Widget _buildSlider1Text(double screenWidth) {
    return _buildSliderText(
      screenWidth,
      'Your Personal App,\nYour Personalised Shorts.',
      'Our AI engine intuitively understands what you like reading.',
    );
  }

  // RESPONSIVE SLIDER 2
  Widget _buildSlider2(double screenWidth) {
    return VisibilityDetector(
      key: const Key('slider-2'),
      onVisibilityChanged: (info) => _updateOpacity(1, info.visibleFraction),
      child: AnimatedOpacity(
        opacity: _opacities[1],
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: Transform.translate(
          offset: Offset(0, (1 - _opacities[1]) * 12),
          child: _buildSliderSection(
            screenWidth,
            'assets/images/3rd.png',
            _buildSlider2Text(screenWidth),
            imageLeft: true,
          ),
        ),
      ),
    );
  }

  Widget _buildSlider2Text(double screenWidth) {
    return _buildSliderText(
      screenWidth,
      'Explore an array of news\ncategories, all in one place.',
      'Browse categories and see trending news instantly.',
    );
  }

  // RESPONSIVE SLIDER 3
  Widget _buildSlider3(double screenWidth) {
    return VisibilityDetector(
      key: const Key('slider-3'),
      onVisibilityChanged: (info) => _updateOpacity(2, info.visibleFraction),
      child: AnimatedOpacity(
        opacity: _opacities[2],
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: Transform.translate(
          offset: Offset(0, (1 - _opacities[2]) * 12),
          child: _buildSliderSection(
            screenWidth,
            'assets/images/4th.png',
            _buildSlider3Text(screenWidth),
            imageLeft: false,
          ),
        ),
      ),
    );
  }

  Widget _buildSlider3Text(double screenWidth) {
    return _buildSliderText(
      screenWidth,
      'Your favourite sources in\none app TEN .',
      'We pick-up articles from all your favourite sources and present them in 60-word shorts.  '
          'Read full articles for shorts that interest you, within the app.',
    );
  }

  // GENERIC SLIDER SECTION
  Widget _buildSliderSection(
    double screenWidth,
    String imagePath,
    Widget textWidget, {
    bool imageLeft = false,
  }) {
    final isMobile = _isMobile(screenWidth);
    final isTablet = _isTablet(screenWidth);
    final imageWidth = isMobile ? 200.0 : (isTablet ? 220.0 : 240.0);

    return Container(
      constraints: const BoxConstraints(maxWidth: 1400),
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(screenWidth),
        vertical: isMobile ? 60 : (isTablet ? 80 : 120),
      ),
      child: isMobile || isTablet
          ? Column(
              children: [
                if (imageLeft) ...[
                  _buildSliderImage(imagePath, imageWidth),
                  SizedBox(height: isMobile ? 32 : 40),
                  textWidget,
                ] else ...[
                  textWidget,
                  SizedBox(height: isMobile ? 32 : 40),
                  _buildSliderImage(imagePath, imageWidth),
                ],
              ],
            )
          : Row(
              children: imageLeft
                  ? [
                      _buildSliderImage(imagePath, 260),
                      const SizedBox(width: 80),
                      Expanded(child: textWidget),
                    ]
                  : [
                      Expanded(child: textWidget),
                      const SizedBox(width: 80),
                      _buildSliderImage(imagePath, 260),
                    ],
            ),
    );
  }

  Widget _buildSliderImage(String path, double width) {
    return Image.asset(
      path,
      width: width,
      errorBuilder: (context, error, stack) => Container(
        width: width,
        height: width * 1.6,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildSliderText(
      double screenWidth, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _isMobile(screenWidth) ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF40607),
            height: 1.3,
          ),
        ),
        SizedBox(height: _isMobile(screenWidth) ? 16 : 24),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _getBodyFontSize(screenWidth),
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // RESPONSIVE FEATURED SECTION
  Widget _buildFeaturedSection(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical:
            _isMobile(screenWidth) ? 60 : (_isTablet(screenWidth) ? 100 : 140),
      ),
      child: Column(
        children: [
          _buildSectionTitle('Shorts, Videos & Detail News'),
          SizedBox(height: _isMobile(screenWidth) ? 32 : 48),
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(
              vertical: _isMobile(screenWidth) ? 32 : 60,
              horizontal: 16,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: _isMobile(screenWidth) ? 24 : 40,
              runSpacing: 24,
              children: ['11', '22', '33']
                  .map((name) => Image.asset(
                        'assets/images/$name.png',
                        height: _isMobile(screenWidth) ? 55 : 75,
                        errorBuilder: (context, error, stack) => Container(
                          height: 75,
                          width: 120,
                          color: Colors.grey[300],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // RESPONSIVE BUSINESS SECTION
  Widget _buildBusinessSection(double screenWidth) {
    final isMobile = _isMobile(screenWidth);
    final isTablet = _isTablet(screenWidth);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: isMobile ? 60 : 80),
      child: Column(
        children: [
          _buildSectionTitle('Best in the Business'),
          SizedBox(height: isMobile ? 32 : 48),
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 40 : 56,
              horizontal: _getHorizontalPadding(screenWidth),
            ),
            child: isMobile
                ? Column(
                    children: [
                      _buildBusinessCard(screenWidth, 'rating',
                          'Loved by Users', 'Rating of 4.6 on Playstore'),
                      const SizedBox(height: 40),
                      _buildBusinessCard(screenWidth, 'andlogo',
                          'Loved by app stores', 'Featured by Apple & Google'),
                      const SizedBox(height: 40),
                      _buildBusinessCard(screenWidth, 'publisher',
                          'Loved by publishers', '30+ global content partners'),
                    ],
                  )
                : isTablet
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 40,
                        runSpacing: 40,
                        children: [
                          _buildBusinessCard(screenWidth, 'rating',
                              'Loved by Users', 'Rating of 4.6 on Playstore'),
                          _buildBusinessCard(
                              screenWidth,
                              'andlogo',
                              'Loved by app stores',
                              'Featured by Apple & Google'),
                          _buildBusinessCard(
                              screenWidth,
                              'publisher',
                              'Loved by publishers',
                              '30+ global content partners'),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBusinessCard(screenWidth, 'rating',
                              'Loved by Users', 'Rating of 4.6 on Playstore'),
                          _buildBusinessCard(
                              screenWidth,
                              'andlogo',
                              'Loved by app stores',
                              'Featured by Apple & Google'),
                          _buildBusinessCard(
                              screenWidth,
                              'publisher',
                              'Loved by publishers',
                              '30+ global content partners'),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(
      double screenWidth, String imageName, String title, String subtitle) {
    return SizedBox(
      width: _isMobile(screenWidth) ? double.infinity : 280,
      child: Column(
        children: [
          Image.asset(
            'assets/images/$imageName.png',
            height: _isMobile(screenWidth) ? 70 : 80,
            errorBuilder: (context, error, stack) => Container(
              height: 80,
              width: 80,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: _isMobile(screenWidth) ? 12 : 16),
          Text(
            title,
            style: TextStyle(
              fontSize: _isMobile(screenWidth) ? 15 : 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF40607),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: _isMobile(screenWidth) ? 13 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 🔥 RESPONSIVE CONTACT US SECTION
  Widget _buildContactSection(double screenWidth) {
    final isMobile = _isMobile(screenWidth);
    final isTablet = _isTablet(screenWidth);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(screenWidth),
        vertical: isMobile ? 60 : (isTablet ? 80 : 100),
      ),
      color: Colors.grey[50],
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: isMobile
            ? Column(
                children: [
                  _buildContactImage(screenWidth),
                  const SizedBox(height: 40),
                  _buildContactInfo(screenWidth),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: _buildContactImage(screenWidth)),
                  SizedBox(width: isTablet ? 40 : 80),
                  Expanded(flex: 5, child: _buildContactInfo(screenWidth)),
                ],
              ),
      ),
    );
  }

  Widget _buildContactImage(double screenWidth) {
    final isMobile = _isMobile(screenWidth);
    final imageSize =
        isMobile ? 280.0 : (_isTablet(screenWidth) ? 320.0 : 400.0);

    return Center(
      child: Image.asset(
        'assets/images/contact.avif',
        width: imageSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) => Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              const Icon(Icons.contact_support, size: 80, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildContactInfo(double screenWidth) {
    final isMobile = _isMobile(screenWidth);
    final titleFontSize =
        isMobile ? 32.0 : (_isTablet(screenWidth) ? 36.0 : 42.0);
    final bodyFontSize = _getBodyFontSize(screenWidth);

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF40607),
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        SizedBox(height: isMobile ? 16 : 24),
        Text(
          'Have feedback or want to partner with us? We\'d love to hear from you.  Reach out using any of the options below.',
          style: TextStyle(
            fontSize: bodyFontSize,
            color: Colors.grey[700],
            height: 1.6,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        SizedBox(height: isMobile ? 32 : 40),
        _buildContactItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: 'contact@eminentnews.com',
          screenWidth: screenWidth,
        ),
        SizedBox(height: isMobile ? 20 : 24),
        _buildContactItem(
          icon: Icons.email_outlined,
          label: 'Email 2',
          value: 'support@eminentnews.com',
          screenWidth: screenWidth,
        ),
        SizedBox(height: isMobile ? 20 : 24),
        _buildContactItem(
          icon: Icons.location_on_outlined,
          label: 'Address',
          value: 'Gorakhpur, UP, India 273413',
          screenWidth: screenWidth,
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required double screenWidth,
  }) {
    final isMobile = _isMobile(screenWidth);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF40607).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: isMobile ? 24 : 28,
            color: const Color(0xFFF40607),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment:
                isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 15 : 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // RESPONSIVE DOWNLOAD SECTION
  Widget _buildDownloadSection(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        bottom: _isMobile(screenWidth) ? 60 : 100,
        left: 16,
        right: 16,
      ),
      child: Column(
        children: [
          Text(
            'Download the easiest way to stay informed',
            style: TextStyle(
              fontSize: _isMobile(screenWidth) ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _isMobile(screenWidth) ? 20 : 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildStoreButton('assets/images/appStore.png', screenWidth),
              _buildStoreButton('assets/images/playStore.png', screenWidth),
            ],
          ),
        ],
      ),
    );
  }
}
