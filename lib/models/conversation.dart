import 'comment_user.dart';

class ConversationProject {
  final int id;
  final String name;

  ConversationProject({
    required this.id,
    required this.name,
  });

  factory ConversationProject.fromJson(Map<String, dynamic> json) {
    return ConversationProject(
      id: json['id'],
      name: json['name'],
    );
  }
}

class LastMessage {
  final int id;
  final String? body;
  final String? fileUrl;
  final DateTime createdAt;
  final CommentUser? user;

  LastMessage({
    required this.id,
    this.body,
    this.fileUrl,
    required this.createdAt,
    this.user,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'],
      body: json['body'],
      fileUrl: json['file_url'],
      createdAt: DateTime.parse(json['created_at']),
      // Correction (même raison que Comment.user) : la relation "user" doit
      // être chargée côté Laravel (->with('lastMessage.user:id,name')) pour
      // être présente ; sinon json['user'] est null.
      user: json['user'] != null ? CommentUser.fromJson(json['user']) : null,
    );
  }
}

class Conversation {
  final int id;
  final String type;
  final String? name;
  final ConversationProject? project;
  final LastMessage? lastMessage;
  final int unreadCount;
  final DateTime? lastMessageAt;

  Conversation({
    required this.id,
    required this.type,
    this.name,
    this.project,
    this.lastMessage,
    required this.unreadCount,
    this.lastMessageAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      project: json['project'] != null
          ? ConversationProject.fromJson(json['project'])
          : null,
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
    );
  }
}
