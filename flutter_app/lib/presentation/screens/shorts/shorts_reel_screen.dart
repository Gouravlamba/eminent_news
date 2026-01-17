import 'package:eminent_news_flutter/presentation/widgets/common/app_header.dart';
import 'package:eminent_news_flutter/presentation/widgets/common/mobile_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:go_router/go_router.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/common/loading_widget.dart';

class ShortsReelScreen extends ConsumerStatefulWidget {
  const ShortsReelScreen({super.key});

  @override
  ConsumerState<ShortsReelScreen> createState() => _ShortsReelScreenState();
}

class _ShortsReelScreenState extends ConsumerState<ShortsReelScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(shortsProvider.notifier).fetchShorts());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortsState = ref.watch(shortsProvider);

    if (shortsState.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: LoadingWidget(),
        // ✅ Bottom nav comes from MainLayout
      );
    }

    if (shortsState.shorts.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: const AppHeader(), // Use custom header
        drawer: const MobileMenuDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_library, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                'No shorts available',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    ref.read(shortsProvider.notifier).fetchShorts(),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
        // ✅ Bottom nav comes from MainLayout
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: shortsState.shorts.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          final short = shortsState.shorts[index];
          return _ShortVideoPlayer(
            videoUrl: short.videoUrl,
            title: short.title,
            description: short.description ?? '',
            editorName: short.editorName,
            isActive: index == _currentIndex,
            onLike: () => ref.read(shortsProvider.notifier).likeShort(short.id),
            onBack: () => context.go('/home'),
          );
        },
      ),
      // ✅ Bottom nav comes from MainLayout automatically
    );
  }
}

// ===================================================================
// VIDEO PLAYER WIDGET (ALL UI AND LOGIC PRESERVED - NO CHANGES)
// ===================================================================

class _ShortVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String editorName;
  final bool isActive;
  final VoidCallback onLike;
  final VoidCallback onBack;

  const _ShortVideoPlayer({
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.editorName,
    required this.isActive,
    required this.onLike,
    required this.onBack,
  });

  @override
  State<_ShortVideoPlayer> createState() => _ShortVideoPlayerState();
}

class _ShortVideoPlayerState extends State<_ShortVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: widget.isActive,
      looping: true,
      showControls: false,
      aspectRatio: 9 / 16,
    );

    setState(() => _isInitialized = true);
  }

  @override
  void didUpdateWidget(_ShortVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _videoController.play();
      } else {
        _videoController.pause();
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
    } else {
      _videoController.play();
    }
    setState(() {});
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoController.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player
          Center(
            child: Chewie(controller: _chewieController!),
          ),

          // Top Back Button
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: widget.onBack,
            ),
          ),

          // Right Side Actions
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                // Like Button
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  iconSize: 32,
                  onPressed: widget.onLike,
                ),
                const SizedBox(height: 24),

                // Share Button
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  iconSize: 32,
                  onPressed: () {
                    // TODO:  Implement share
                  },
                ),
                const SizedBox(height: 24),

                // Mute/Unmute Button
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                  ),
                  iconSize: 32,
                  onPressed: _toggleMute,
                ),
              ],
            ),
          ),

          // Bottom Info
          Positioned(
            left: 16,
            right: 80,
            bottom: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editor Name
                Text(
                  '@${widget.editorName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Description
                if (widget.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Play/Pause Indicator
          if (!_videoController.value.isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
