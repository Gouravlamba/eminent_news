class ShortModel {
  final String id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? publicId;
  final String? thumbnail;
  final int? duration;
  final String? videoMimeType;
  final List<ShortLike> likes;
  final ShortEditor? editor;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShortModel({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.publicId,
    this.thumbnail,
    this.duration,
    this.videoMimeType,
    this.likes = const [],
    this.editor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShortModel.fromJson(Map<String, dynamic> json) {
    return ShortModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['videoUrl'] ?? '',
      publicId: json['publicId'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
      videoMimeType: json['videoMimeType'] ?? 'video/mp4',
      likes: (json['likes'] as List<dynamic>?)
              ?.map((e) => ShortLike.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      editor: json['editor'] != null
          ? (json['editor'] is String
              ? ShortEditor(id: json['editor'])
              : ShortEditor.fromJson(json['editor'] as Map<String, dynamic>))
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
      'videoUrl': videoUrl,
      'publicId': publicId,
      'thumbnail': thumbnail,
      'duration': duration,
      'videoMimeType': videoMimeType,
      'likes': likes.map((e) => e.toJson()).toList(),
      'editor': editor?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool isLikedBy(String userId) {
    return likes.any((like) => like.user == userId);
  }
}

class ShortLike {
  final String user;

  ShortLike({required this.user});

  factory ShortLike.fromJson(Map<String, dynamic> json) {
    return ShortLike(user: json['user'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'user': user};
  }
}

class ShortEditor {
  final String id;
  final String? name;
  final String? email;

  ShortEditor({
    required this.id,
    this.name,
    this.email,
  });

  factory ShortEditor.fromJson(Map<String, dynamic> json) {
    return ShortEditor(
      id: json['_id'] ?? '',
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}
