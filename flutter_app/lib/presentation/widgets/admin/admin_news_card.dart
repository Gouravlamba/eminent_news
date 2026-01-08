import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/news_model.dart';

class AdminNewsCard extends StatelessWidget {
  final NewsModel news;
  final VoidCallback onDelete;

  const AdminNewsCard({
    super.key,
    required this.news,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Action Buttons
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: news.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: news.images[0],
                        fit: BoxFit.cover,
                      )
                    : Container(color: Colors.grey[300]),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.8),
                  ),
                  onPressed: onDelete,
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Chip(
                    label: Text(news.category),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 10,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),

                  // Editor
                  if (news.editor != null)
                    Text(
                      'By ${news.editor!.name}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
