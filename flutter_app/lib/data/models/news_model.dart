class NewsModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> subCategories;
  final String? videoUrl;
  final List<String> images;
  final List<LikeModel> likes;
  final EditorModel? editor;
  final String createdAt;
  final List<CommentModel> comments;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.subCategories = const [],
    this.videoUrl,
    required this.images,
    this.likes = const [],
    this.editor,
    required this.createdAt,
    this.comments = const [],
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'National',
      subCategories: json['subCategories'] != null
          ? List<String>.from(json['subCategories'])
          : [],
      videoUrl: json['videoUrl'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      likes: json['likes'] != null
          ? (json['likes'] as List)
              .map((e) => LikeModel.fromJson(
                  e is Map<String, dynamic> ? e : {'user': e}))
              .toList()
          : [],
      editor: json['editor'] != null && json['editor'] is Map
          ? EditorModel.fromJson(json['editor'])
          : null,
      createdAt: json['createdAt'] ?? '',
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((e) => CommentModel.fromJson(e))
              .toList()
          : [],
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
      'editor': editor?.toJson(),
      'createdAt': createdAt,
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }

  int get likesCount => likes.length;
  int get commentsCount => comments.length;
}

class EditorModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final List<FollowerModel> followers;

  EditorModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.followers = const [],
  });

  factory EditorModel.fromJson(Map<String, dynamic> json) {
    return EditorModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      followers: json['followers'] != null
          ? (json['followers'] as List)
              .map((e) => FollowerModel.fromJson(
                  e is Map<String, dynamic> ? e : {'user': e}))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'email': email,
      'followers': followers.map((e) => e.toJson()).toList(),
    };
  }

  int get followersCount => followers.length;
}

class LikeModel {
  final String user;

  LikeModel({required this.user});

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(user: json['user']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {'user': user};
}

class FollowerModel {
  final String user;

  FollowerModel({required this.user});

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(user: json['user']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {'user': user};
}

class CommentModel {
  final String user;
  final String comment;

  CommentModel({required this.user, required this.comment});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      user: json['user'] ?? '',
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'user': user, 'comment': comment};
}
