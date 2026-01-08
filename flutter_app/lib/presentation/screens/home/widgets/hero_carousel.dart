import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../data/models/ads_model.dart';

class HeroCarousel extends StatefulWidget {
  final List<AdsModel> ads;
  final int intervalMs;

  const HeroCarousel({
    super.key,
    required this.ads,
    this.intervalMs = 5000,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late List<AdsModel> slides;
  int index = 0;
  bool isPaused = false;
  Timer? intervalTimer;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Take first 3 ads (matching React:  ads.slice(0, 3))
    slides = (widget.ads).take(3).toList();
    _startAutoplay();
  }

  @override
  void didUpdateWidget(HeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ads != oldWidget.ads ||
        widget.intervalMs != oldWidget.intervalMs) {
      slides = (widget.ads).take(3).toList();
      _restartAutoplay();
    }
  }

  @override
  void dispose() {
    // Cleanup (matching React useEffect cleanup)
    intervalTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  // Autoplay logic (matches React useEffect)
  void _startAutoplay() {
    if (slides.length <= 1) return;

    // Clear previous interval
    intervalTimer?.cancel();

    if (!isPaused) {
      intervalTimer = Timer.periodic(
        Duration(milliseconds: widget.intervalMs),
        (timer) {
          if (mounted) {
            setState(() {
              index = (index + 1) % slides.length;
            });
          }
        },
      );
    }
  }

  void _restartAutoplay() {
    intervalTimer?.cancel();
    _startAutoplay();
  }

  // Pause autoplay (matches React onMouseEnter)
  void _pauseAutoplay() {
    setState(() {
      isPaused = true;
    });
    intervalTimer?.cancel();
  }

  // Resume autoplay (matches React onMouseLeave)
  void _resumeAutoplay() {
    setState(() {
      isPaused = false;
    });
    _startAutoplay();
  }

  // Keyboard navigation (matches React onKeyDown)
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          index = (index - 1 + slides.length) % slides.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          index = (index + 1) % slides.length;
        });
      }
    }
  }

  // Go to previous slide
  void _previousSlide() {
    setState(() {
      index = (index - 1 + slides.length) % slides.length;
    });
  }

  // Go to next slide
  void _nextSlide() {
    setState(() {
      index = (index + 1) % slides.length;
    });
  }

  // Go to specific slide (dot navigation)
  void _goToSlide(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return null equivalent (empty widget)
    if (slides.isEmpty) return const SizedBox.shrink();

    return MouseRegion(
      onEnter: (_) => _pauseAutoplay(),
      onExit: (_) => _resumeAutoplay(),
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: (node, event) {
          _handleKeyEvent(event);
          return KeyEventResult.handled;
        },
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Container(
            width: double.infinity,
            height: 250, // Matches md:h-[64vh] on mobile
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Slides wrapper (matches React flex animation)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(
                    -index * MediaQuery.of(context).size.width,
                    0,
                    0,
                  ),
                  child: Row(
                    children: slides.map((post) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image
                            CachedNetworkImage(
                              imageUrl:
                                  post.images.isNotEmpty ? post.images[0] : '',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
                            ),

                            // Gradient overlay (matches bg-gradient-to-t)
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.75),
                                  ],
                                ),
                              ),
                            ),

                            // Text content (matches absolute bottom positioning)
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title (matches text-xl md:text-3xl)
                                  Text(
                                    post.title,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  768
                                              ? 28
                                              : 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),

                                  // Description (hidden on small screens)
                                  if (MediaQuery.of(context).size.width > 640)
                                    Text(
                                      post.description,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    768
                                                ? 16
                                                : 14,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Previous button (only if multiple slides)
                if (slides.length > 1)
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: Colors.white, size: 24),
                          onPressed: _previousSlide,
                          tooltip: 'Previous slide',
                        ),
                      ),
                    ),
                  ),

                // Next button (only if multiple slides)
                if (slides.length > 1)
                  Positioned(
                    right: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right,
                              color: Colors.white, size: 24),
                          onPressed: _nextSlide,
                          tooltip: 'Next slide',
                        ),
                      ),
                    ),
                  ),

                // Dots indicator (matches absolute bottom positioning)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (i) {
                      return GestureDetector(
                        onTap: () => _goToSlide(i),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            boxShadow: i == index
                                ? [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
