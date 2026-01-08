import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/news_model.dart';

class PostCardSmall extends StatelessWidget {
  final NewsModel news;
  final VoidCallback? fetchNews;

  const PostCardSmall({
    super.key,
    required this.news,
    this.fetchNews,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/news/${news.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                news.images.isNotEmpty ? news.images[0] : '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
