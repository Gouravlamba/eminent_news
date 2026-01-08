import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../providers/news_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../../data/services/news_service.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  bool _liked = false;
  int _likesCount = 0;
  bool _followed = false;
  bool _loadingLike = false;
  bool _loadingFollow = false;

  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleLike(String newsId, String? currentUserId) async {
    if (_loadingLike) return;

    if (currentUserId == null) {
      Fluttertoast.showToast(msg: 'Please Login First!! ');
      context.go('/login');
      return;
    }

    setState(() {
      _loadingLike = true;
      _liked = !_liked;
      _likesCount = _liked ? _likesCount + 1 : _likesCount - 1;
    });

    try {
      final newsService = ref.read(newsServiceProvider);
      final result = await newsService.toggleLike(newsId);

      setState(() {
        _likesCount = result['likesCount'] ?? _likesCount;
      });

      Fluttertoast.showToast(
        msg: result['message'] ?? 'Success',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      setState(() {
        _liked = !_liked;
        _likesCount = _liked ? _likesCount + 1 : _likesCount - 1;
      });
      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => _loadingLike = false);
    }
  }

  Future<void> _handleFollow(String? editorId, String? currentUserId) async {
    if (_loadingFollow) return;

    if (currentUserId == null) {
      Fluttertoast.showToast(msg: 'Please Login First!!');
      context.go('/login');
      return;
    }

    if (editorId == null) {
      Fluttertoast.showToast(msg: 'Editor information unavailable');
      return;
    }

    setState(() {
      _loadingFollow = true;
      _followed = !_followed;
    });

    try {
      final newsService = ref.read(newsServiceProvider);
      final result = await newsService.toggleFollow(editorId);

      Fluttertoast.showToast(
        msg: result['message'] ?? 'Success',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      setState(() => _followed = !_followed);
      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => _loadingFollow = false);
    }
  }

  Future<void> _handleShare(String title) async {
    try {
      await Share.share('Check out this news: $title');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to share');
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsDetailProvider(widget.newsId));
    final currentUser = ref.watch(authProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              newsAsync.whenData((news) => _handleShare(news.title));
            },
          ),
        ],
      ),
      body: newsAsync.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                error.toString().replaceAll('Exception: ', ''),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/news'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
        data: (news) {
          // Initialize like/follow state
          if (_likesCount == 0) {
            _likesCount = news.likesCount;
            if (currentUser != null) {
              _liked = news.likes.any((l) => l.user == currentUser.id);
              _followed =
                  news.editor?.followers.any((f) => f.user == currentUser.id) ??
                      false;
            }
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Images Carousel
                if (news.images.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: news.images.length > 1,
                    ),
                    items: news.images.map((imageUrl) {
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      );
                    }).toList(),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      Chip(
                        label: Text(news.category),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        news.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Editor Info & Follow Button
                      if (news.editor != null)
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: Text(
                                news.editor!.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news.editor!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${news.editor!.followersCount} followers',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _loadingFollow
                                  ? null
                                  : () => _handleFollow(
                                      news.editor?.id, currentUser?.id),
                              icon: Icon(
                                  _followed ? Icons.check : Icons.person_add),
                              label: Text(_followed ? 'Following' : 'Follow'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _followed
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Date
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(news.createdAt),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        news.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          // Like Button
                          ElevatedButton.icon(
                            onPressed: _loadingLike
                                ? null
                                : () => _handleLike(news.id, currentUser?.id),
                            icon: Icon(_liked
                                ? Icons.favorite
                                : Icons.favorite_border),
                            label: Text('$_likesCount'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _liked
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[300],
                              foregroundColor:
                                  _liked ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Comment Button
                          OutlinedButton.icon(
                            onPressed: () {
                              // Scroll to comments section
                            },
                            icon: const Icon(Icons.comment),
                            label: Text('${news.commentsCount}'),
                          ),
                          const SizedBox(width: 12),

                          // Share Button
                          OutlinedButton.icon(
                            onPressed: () => _handleShare(news.title),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Comments Section
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Comments (${news.commentsCount})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      // Add Comment (only if logged in)
                      if (currentUser != null)
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                  hintText: 'Write a comment...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                if (_commentController.text.trim().isEmpty)
                                  return;

                                try {
                                  final newsService =
                                      ref.read(newsServiceProvider);
                                  await newsService.addComment(
                                    news.id,
                                    _commentController.text.trim(),
                                  );
                                  _commentController.clear();
                                  Fluttertoast.showToast(
                                    msg: 'Comment added',
                                    backgroundColor: Colors.green,
                                  );
                                  ref.invalidate(
                                      newsDetailProvider(widget.newsId));
                                } catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e
                                        .toString()
                                        .replaceAll('Exception: ', ''),
                                    backgroundColor: Colors.red,
                                  );
                                }
                              },
                              icon: const Icon(Icons.send),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Comments List
                      if (news.comments.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('No comments yet'),
                          ),
                        )
                      else
                        ...news.comments.map((comment) => Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.user,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(comment.comment),
                                  ],
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
