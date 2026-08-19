import 'comment_user.dart';

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

class ConversationMember {
  final int id;
  final String name;
  final String? role;

  ConversationMember({
    required this.id,
    required this.name,
    this.role,
  });

  factory ConversationMember.fromJson(Map<String, dynamic> json) {
    return ConversationMember(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}

class Conversation {
  final int id;
  final bool isGroup;
  final String? name;
  final LastMessage? lastMessage;
  final int unreadCount;
  final DateTime? lastMessageAt;
  final List<ConversationMember> members;

  Conversation({
    required this.id,
    required this.isGroup,
    this.name,
    this.lastMessage,
    required this.unreadCount,
    this.lastMessageAt,
    this.members = const [],
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      isGroup: json['is_group'] ?? false,
      name: json['name'],
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      // Présent sur getConversation/createDirect/createGroup, absent de
      // getConversations (liste) — d'où la valeur par défaut [].
      members: json['members'] != null
          ? (json['members'] as List)
              .map((e) => ConversationMember.fromJson(e))
              .toList()
          : const [],
    );
  }
}
