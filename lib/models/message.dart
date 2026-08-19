class MessageUser {
  final int id;
  final String name;
  final String? role;

  MessageUser({
    required this.id,
    required this.name,
    this.role,
  });

  factory MessageUser.fromJson(Map<String, dynamic> json) {
    return MessageUser(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}

class Message {
  final int id;
  // Nullable : GET /conversations/{id}/files ne sélectionne pas cette
  // colonne (get(['id','user_id','file_url','created_at'])), donc absente
  // du JSON pour cet endpoint.
  final int? conversationId;
  final int userId;
  final String? body;
  final String? fileUrl;
  final DateTime createdAt;
  final MessageUser? user;

  Message({
    required this.id,
    this.conversationId,
    required this.userId,
    this.body,
    this.fileUrl,
    required this.createdAt,
    this.user,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      userId: json['user_id'],
      body: json['body'],
      fileUrl: json['file_url'],
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'] != null ? MessageUser.fromJson(json['user']) : null,
    );
  }
}
