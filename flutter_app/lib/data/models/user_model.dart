class UserModel {
  final String id;
  final String name;
  final String email;
  final String? dob;
  final String role;
  final List<String> followers;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dob,
    required this.role,
    this.followers = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'],
      role: json['role'] ?? 'user',
      followers:
          json['followers'] != null ? List<String>.from(json['followers']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'dob': dob,
      'role': role,
      'followers': followers,
    };
  }

  bool get isAdmin => role == 'admin';
  bool get isEditor => role == 'editor';
  bool get isUser => role == 'user';
}
