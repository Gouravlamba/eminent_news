import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/news_model.dart';
import '../../../data/services/news_service.dart';
import '../../providers/auth_provider.dart';

class PostCard extends ConsumerStatefulWidget {
  final NewsModel news;
  final VoidCallback? fetchNews;

  const PostCard({
    super.key,
    required this.news,
    this.fetchNews,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  late bool liked;
  late int likesCount;
  late bool followed;
  bool loadingLike = false;
  bool loadingFollow = false;

  @override
  void initState() {
    super.initState();
    liked = false;
    likesCount = widget.news.likesCount;
    followed = false;
    _initializeState();
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.news != oldWidget.news) {
      _initializeState();
    }
  }

  void _initializeState() {
    final currentUser = ref.read(authProvider).currentUser;
    if (currentUser == null) return;

    final myId = currentUser.id;
    final isLiked = widget.news.likes.any((l) => l.user == myId);
    final isFollowing =
        widget.news.editor?.followers.any((f) => f.user == myId) ?? false;

    setState(() {
      liked = isLiked;
      likesCount = widget.news.likesCount;
      followed = isFollowing;
    });
  }

  Future<void> _handleLike() async {
    if (loadingLike) return;

    final currentUser = ref.read(authProvider).currentUser;
    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "Please Login First !! ",
        backgroundColor: Colors.red,
      );
      context.go('/login');
      return;
    }

    setState(() => loadingLike = true);

    final willLike = !liked;
    setState(() {
      liked = willLike;
      likesCount =
          willLike ? likesCount + 1 : (likesCount - 1).clamp(0, 999999);
    });

    try {
      final newsService = ref.read(newsServiceProvider);
      final result = await newsService.toggleLike(widget.news.id);

      if (result['likesCount'] != null) {
        setState(() => likesCount = result['likesCount']);
      }

      Fluttertoast.showToast(
        msg: result['message'] ?? (willLike ? "Liked" : "Unliked"),
        backgroundColor: Colors.green,
      );
    } catch (err) {
      setState(() {
        liked = !willLike;
        likesCount =
            willLike ? (likesCount - 1).clamp(0, 999999) : likesCount + 1;
      });

      Fluttertoast.showToast(
        msg: err.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => loadingLike = false);
    }
  }

  Future<void> _handleFollow() async {
    if (loadingFollow) return;

    final currentUser = ref.read(authProvider).currentUser;
    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "Please Login First !!",
        backgroundColor: Colors.red,
      );
      context.go('/login');
      return;
    }

    final editorId = widget.news.editor?.id;
    if (editorId == null) {
      Fluttertoast.showToast(
        msg: "Editor information unavailable",
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => loadingFollow = true);

    final willFollow = !followed;
    setState(() => followed = willFollow);

    try {
      final newsService = ref.read(newsServiceProvider);
      final result = await newsService.toggleFollow(editorId);

      Fluttertoast.showToast(
        msg: result['message'] ?? (willFollow ? "Following" : "Unfollowed"),
        backgroundColor: Colors.green,
      );

      widget.fetchNews?.call();
    } catch (err) {
      setState(() => followed = !willFollow);

      Fluttertoast.showToast(
        msg: err.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => loadingFollow = false);
    }
  }

  Future<void> _handleShare() async {
    try {
      await Clipboard.setData(
        ClipboardData(text: 'https://yourapp.com/news/${widget.news.id}'),
      );
      Fluttertoast.showToast(
        msg: "Link copied to clipboard!",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to copy link.",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/news/${widget.news.id}'),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 10 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 TOP:  Author + Follow Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Author info
                  Expanded(
                    child: Row(
                      children: [
                        // Avatar placeholder
                        CircleAvatar(
                          radius: isMobile ? 18 : 16,
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            (widget.news.editor?.name ?? 'E')[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.news.editor?.name ?? 'Editor',
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '@${widget.news.editor?.email.split('@')[0] ?? 'editor'}',
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Follow icon button
                  IconButton(
                    onPressed: loadingFollow ? null : _handleFollow,
                    icon: loadingFollow
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            followed
                                ? Icons.person_remove
                                : Icons.person_add_outlined,
                            size: isMobile ? 24 : 22,
                            color: followed
                                ? const Color(0xFFF40607)
                                : Colors.grey[700],
                          ),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 12 : 10),

              // 🔥 TITLE
              Text(
                widget.news.title,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: isMobile ? 8 : 6),

              // 🔥 DESCRIPTION
              Text(
                widget.news.description,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: isMobile ? 12 : 10),

              // 🔥 IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.news.images.isNotEmpty
                      ? widget.news.images[0]
                      : 'https://via.placeholder.com/600x300',
                  height: isMobile ? 200 : 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: isMobile ? 200 : 180,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: isMobile ? 200 : 180,
                    color: Colors.grey[200],
                    child:
                        const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 12 : 10),

              // 🔥 BOTTOM:  Like, Comment, Share + Read More
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side actions
                  Row(
                    children: [
                      // Like button
                      InkWell(
                        onTap: loadingLike ? null : _handleLike,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                liked ? Icons.favorite : Icons.favorite_border,
                                size: isMobile ? 18 : 15,
                                color: liked
                                    ? const Color(0xFFF40607)
                                    : Colors.grey[700],
                              ),
                              if (likesCount > 0) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '$likesCount',
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Comment button (icon with count)
                      InkWell(
                        onTap: () => context.go('/news/${widget.news.id}'),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: isMobile ? 18 : 15,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 13,
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
                        onTap: _handleShare,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          child: Icon(
                            Icons.share_outlined,
                            size: isMobile ? 18 : 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Right:  Read more link
                  InkWell(
                    onTap: () => context.go('/news/${widget.news.id}'),
                    child: Text(
                      'Read more →',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 13,
                        color: const Color(0xFFF40607),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
