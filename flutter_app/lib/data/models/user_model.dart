class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? avatar;
  final String role;
  final String? address;
  final String? phone;
  final bool verified;
  final List<Follower> followers;
  final List<Follower> following;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatar,
    required this.role,
    this.address,
    this.phone,
    this.verified = false,
    this.followers = const [],
    this.following = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      role: json['role'] ?? 'user',
      address: json['address'],
      phone: json['phone'],
      verified: json['verified'] ?? false,
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => Follower.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => Follower.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'email': email,
      'avatar': avatar,
      'role': role,
      'address': address,
      'phone': phone,
      'verified': verified,
      'followers': followers.map((e) => e.toJson()).toList(),
      'following': following.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isEditor => role == 'editor';
  bool get isUser => role == 'user';
}

class Follower {
  final String user;
  final DateTime followedAt;

  Follower({
    required this.user,
    required this.followedAt,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      user: json['user'] ?? '',
      followedAt: DateTime.parse(json['followedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'followedAt': followedAt.toIso8601String(),
    };
  }
}
