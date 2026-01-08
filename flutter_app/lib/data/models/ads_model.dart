class AdsModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String url;
  final List<String> images;
  final String createdAt;

  AdsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.url,
    required this.images,
    required this.createdAt,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Banner',
      url: json['url'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      createdAt: json['createdAt'] ?? '',
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
      'createdAt': createdAt,
    };
  }

  bool get isBanner => category == 'Banner';
  bool get isHighlight => category == 'Highlights';
}
