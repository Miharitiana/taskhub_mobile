import 'comment_user.dart';

class Comment {
  final int id;
  final int taskId;
  final int userId;
  final String? body;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Nullable : côté Laravel, la relation "user" doit être chargée via
  // ->load('user') / ->with('user') pour être présente dans le JSON.
  // Sans ça, json['user'] est null et le parsing ne doit pas planter.
  final CommentUser? user;

  Comment({
    required this.id,
    required this.taskId,
    required this.userId,
    this.body,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      taskId: json['task_id'],
      userId: json['user_id'],
      body: json['body'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      // Correction : ne plus appeler CommentUser.fromJson(null) quand la
      // relation "user" n'est pas chargée par le backend.
      user: json['user'] != null ? CommentUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'body': body,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}