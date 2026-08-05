class User {
  final int id;
  final String name;
  final String login;
  final String email;
  final String? slackUserId;
  final String role;
  final bool isActive;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.login,
    required this.email,
    this.slackUserId,
    required this.role,
    required this.isActive,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      login: json['login'],
      email: json['email'],
      slackUserId: json['slack_user_id'],
      role: json['role'],
      isActive: json['is_active'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "login": login,
      "email": email,
      "slack_user_id": slackUserId,
      "role": role,
      "is_active": isActive,
      "email_verified_at": emailVerifiedAt?.toIso8601String(),
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}