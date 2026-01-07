import 'user_model.dart';

class NewsModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> subCategories;
  final String? videoUrl;
  final List<String> images;
  final List<Like> likes;
  final List<Comment> comments;
  final EditorInfo? editor;
  final DateTime createdAt;
  final DateTime updatedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.subCategories = const [],
    this.videoUrl,
    this.images = const [],
    this.likes = const [],
    this.comments = const [],
    this.editor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: json['videoUrl'],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      likes: (json['likes'] as List<dynamic>?)
              ?.map((e) => Like.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      editor: json['editor'] != null
          ? EditorInfo.fromJson(json['editor'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'subCategories': subCategories,
      'videoUrl': videoUrl,
      'images': images,
      'likes': likes.map((e) => e.toJson()).toList(),
      'comments': comments.map((e) => e.toJson()).toList(),
      'editor': editor?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool isLikedBy(String userId) {
    return likes.any((like) => like.user == userId);
  }
}

class Like {
  final String user;

  Like({required this.user});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(user: json['user'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'user': user};
  }
}

class Comment {
  final String id;
  final String user;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.user,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class EditorInfo {
  final String id;
  final String username;
  final String name;
  final String email;
  final List<String> followers;

  EditorInfo({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.followers = const [],
  });

  factory EditorInfo.fromJson(Map<String, dynamic> json) {
    return EditorInfo(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'name': name,
      'email': email,
      'followers': followers,
    };
  }

  bool isFollowedBy(String userId) {
    return followers.contains(userId);
  }
}
