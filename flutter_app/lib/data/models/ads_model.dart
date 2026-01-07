class AdsModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? url;
  final List<String> images;
  final DateTime createdAt;

  AdsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.url,
    this.images = const [],
    required this.createdAt,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      url: json['url'],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'url': url,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isBanner => category == 'Banner';
  bool get isHighlight => category == 'Highlights';
}
