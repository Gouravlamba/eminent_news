import 'package:eminent_news_flutter/presentation/widgets/common/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../providers/shorts_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/mobile_menu_drawer.dart';

class VideosScreen extends ConsumerStatefulWidget {
  const VideosScreen({super.key});

  @override
  ConsumerState<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends ConsumerState<VideosScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch shorts/videos on init
    Future.microtask(() => ref.read(shortsProvider.notifier).fetchShorts());
  }

  // Mobile responsive
  bool _isMobile(double width) => width < 768;

  @override
  Widget build(BuildContext context) {
    final shortsState = ref.watch(shortsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = _isMobile(screenWidth);

    if (shortsState.isLoading) {
      return const Scaffold(
        appBar: AppHeader(),
        drawer: MobileMenuDrawer(),
        body: LoadingWidget(),
      );
    }

    return Scaffold(
      appBar: const AppHeader(),
      drawer: const MobileMenuDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(shortsProvider.notifier).fetchShorts(),
          child: CustomScrollView(
            slivers: [
              // Title Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 16 : 32,
                    isMobile ? 16 : 24,
                    isMobile ? 16 : 32,
                    isMobile ? 12 : 16,
                  ),
                  child: Text(
                    'Latest Videos',
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Videos List
              if (shortsState.shorts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.video_library_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No videos available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final video = shortsState.shorts[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: isMobile ? 20 : 24,
                          ),
                          child: VideoCard(
                            video: video,
                            onTap: () {
                              // Navigate to video player (shorts screen)
                              context.go('/shorts');
                            },
                            onLike: () {
                              ref
                                  .read(shortsProvider.notifier)
                                  .likeShort(video.id);
                            },
                          ),
                        );
                      },
                      childCount: shortsState.shorts.length,
                    ),
                  ),
                ),

              // Bottom spacing
              SliverToBoxAdapter(
                child: SizedBox(height: isMobile ? 32 : 48),
              ),

              // Footer
              const SliverToBoxAdapter(
                child: FooterWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🎬 VIDEO CARD WIDGET
class VideoCard extends StatefulWidget {
  final dynamic video;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
    required this.onLike,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _thumbnailController;
  bool _isInitialized = false;
  bool _isLiked = false;
  Duration? _videoDuration;

  @override
  void initState() {
    super.initState();
    _initializeThumbnail();
  }

  Future<void> _initializeThumbnail() async {
    try {
      if (widget.video.videoUrl.isEmpty) {
        throw Exception('Video URL is empty');
      }

      _thumbnailController = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      );

      await _thumbnailController!.initialize();

      setState(() {
        _isInitialized = true;
        _videoDuration = _thumbnailController!.value.duration;
      });

      // Seek to 1 second to get a better thumbnail
      await _thumbnailController!.seekTo(const Duration(seconds: 1));
    } catch (e) {
      print('Error loading video thumbnail: $e');
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _thumbnailController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail
          InkWell(
            onTap: widget.onTap,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Thumbnail
                  if (_isInitialized && _thumbnailController != null)
                    VideoPlayer(_thumbnailController!)
                  else
                    Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),

                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),

                  // Play button
                  Center(
                    child: Container(
                      width: isMobile ? 60 : 70,
                      height: isMobile ? 60 : 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: isMobile ? 40 : 50,
                        color: const Color(0xFFF40607),
                      ),
                    ),
                  ),

                  // Duration badge
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDuration(_videoDuration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Video Info
          Padding(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.video.title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isMobile ? 6 : 8),

                // Description
                if (widget.video.description != null &&
                    widget.video.description!.isNotEmpty)
                  Text(
                    widget.video.description!,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: isMobile ? 10 : 12),

                // Meta row (author, likes, share)
                Row(
                  children: [
                    // Author
                    Expanded(
                      child: Text(
                        widget.video.editorName,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Like button
                    InkWell(
                      onTap: () {
                        setState(() => _isLiked = !_isLiked);
                        widget.onLike();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              size: isMobile ? 18 : 20,
                              color: _isLiked ? Colors.red : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.video.likesCount ?? 0}',
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Share button
                    InkWell(
                      onTap: () {
                        // TODO: Implement share
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Share - Coming Soon'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.share_outlined,
                          size: isMobile ? 18 : 20,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
