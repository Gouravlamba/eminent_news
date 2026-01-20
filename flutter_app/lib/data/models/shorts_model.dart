class ShortModel {
  final String id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? publicId;
  final String? thumbnail;
  final int? duration;
  final String? videoMimeType;
  final dynamic editor;
  final String createdAt;
  final String updatedAt;
  final int likesCount; // Added property for likes count

  ShortModel({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.publicId,
    this.thumbnail,
    this.duration,
    this.videoMimeType,
    this.editor,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount, // Added likesCount to the constructor
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
      videoMimeType: json['videoMimeType'],
      editor: json['editor'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      likesCount: json['likesCount'] ??
          0, // Map likesCount from JSON with default value
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
      'editor': editor,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'likesCount': likesCount, // Include likesCount in JSON serialization
    };
  }

  String get editorName {
    if (editor is Map) {
      return editor['name'] ?? 'Unknown';
    }
    return 'Unknown';
  }
}
