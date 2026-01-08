import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
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
  // State variables (matching React useState)
  late bool liked;
  late int likesCount;
  late bool followed;
  bool loadingLike = false;
  bool loadingFollow = false;

  @override
  void initState() {
    super.initState();
    // Initialize state from props
    liked = false;
    likesCount = widget.news.likesCount;
    followed = false;

    // Determine initial liked/followed state (matching React useEffect)
    _initializeState();
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.news != oldWidget.news) {
      _initializeState();
    }
  }

  // Initialize liked/followed state (matches React useEffect logic)
  void _initializeState() {
    final currentUser = ref.read(authProvider).currentUser;

    if (currentUser == null) return;

    final myId = currentUser.id;

    // Determine if I already liked this post
    final isLiked = widget.news.likes.any((l) => l.user == myId);

    // Determine if I already follow this post's editor
    final isFollowing =
        widget.news.editor?.followers.any((f) => f.user == myId) ?? false;

    setState(() {
      liked = isLiked;
      likesCount = widget.news.likesCount;
      followed = isFollowing;
    });
  }

  // Handle Like (matches React handleLike with optimistic updates)
  Future<void> _handleLike() async {
    if (loadingLike) return;

    final currentUser = ref.read(authProvider).currentUser;

    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "Please Login First !!",
        backgroundColor: Colors.red,
      );
      context.go('/login');
      return;
    }

    setState(() => loadingLike = true);

    // Optimistic update
    final willLike = !liked;
    setState(() {
      liked = willLike;
      likesCount =
          willLike ? likesCount + 1 : (likesCount - 1).clamp(0, 999999);
    });

    try {
      final newsService = ref.read(newsServiceProvider);
      final result = await newsService.toggleLike(widget.news.id);

      // Prefer server data if present
      if (result['likesCount'] != null) {
        setState(() {
          likesCount = result['likesCount'];
        });
      }

      Fluttertoast.showToast(
        msg: result['message'] ?? (willLike ? "Liked" : "Unliked"),
        backgroundColor: Colors.green,
      );
    } catch (err) {
      // Rollback on error
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

  // Handle Follow (matches React handleFollow with optimistic updates)
  Future<void> _handleFollow() async {
    if (loadingFollow) return;

    final currentUser = ref.read(authProvider).currentUser;

    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "Please Login First !! ",
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

    // Optimistic update
    final willFollow = !followed;
    setState(() => followed = willFollow);

    try {
      final newsService = ref.read(newsServiceProvider);
      final result = await newsService.toggleFollow(editorId);

      Fluttertoast.showToast(
        msg: result['message'] ?? (willFollow ? "Following" : "Unfollowed"),
        backgroundColor: Colors.green,
      );

      // Refresh news list
      widget.fetchNews?.call();
    } catch (err) {
      // Rollback on error
      setState(() => followed = !willFollow);

      Fluttertoast.showToast(
        msg: err.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => loadingFollow = false);
    }
  }

  // Handle Share (matches React handleShare with clipboard)
  Future<void> _handleShare() async {
    try {
      // Copy link to clipboard
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/news/${widget.news.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (matches React image section)
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.news.images.isNotEmpty
                      ? widget.news.images[0]
                      : 'https://via.placeholder.com/400x200',
                  height: 192,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 192,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 192,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ],
            ),

            // Content (matches React content section)
            Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (matches text-lg md:text-base)
                  Text(
                    widget.news.title,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isMobile ? 8 : 6),

                  // Description (matches text-sm md:text-xs)
                  Text(
                    widget.news.description,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 12,
                      color: Colors.grey[600],
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isMobile ? 8 : 6),

                  // Author + Follow Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Author (matches "By <name>")
                      Expanded(
                        child: Text(
                          'By ${widget.news.editor?.name ?? "Editor"}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Follow Button
                      SizedBox(
                        height: 28,
                        child: OutlinedButton.icon(
                          onPressed: loadingFollow ? null : _handleFollow,
                          icon: loadingFollow
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  Icons.person_add,
                                  size: 14,
                                  color: followed
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                          label: Text(
                            followed ? 'Following' : 'Follow',
                            style: TextStyle(
                              fontSize: 12,
                              color: followed ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: followed
                                ? const Color(0xFFF40607)
                                : Colors.transparent,
                            side: BorderSide(
                              color: followed
                                  ? const Color(0xFFF40607)
                                  : Colors.grey[300]!,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Like + Share + Read More
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left:  Like + Share
                      Row(
                        children: [
                          // Like Button
                          InkWell(
                            onTap: loadingLike ? null : _handleLike,
                            child: Row(
                              children: [
                                Icon(
                                  liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18,
                                  color: liked
                                      ? const Color(0xFFF40607)
                                      : Colors.grey[700],
                                ),
                                if (likesCount > 0) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '$likesCount',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Share Button
                          InkWell(
                            onTap: _handleShare,
                            child: Row(
                              children: [
                                Icon(Icons.share,
                                    size: 18, color: Colors.grey[700]),
                                const SizedBox(width: 4),
                                Text(
                                  'Share',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Right: Read More
                      InkWell(
                        onTap: () => context.go('/news/${widget.news.id}'),
                        child: const Text(
                          'Read more →',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFF40607),
                            fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
