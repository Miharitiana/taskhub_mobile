class AppNotification {
  final String id;
  final String? type;
  final String? title;
  final String? message;
  final int? taskId;
  final int? projectId;
  final String? actorName;
  // Non-final : mis à jour localement (optimiste) après un markAsRead réussi,
  // sans devoir refaire un aller-retour réseau pour rafraîchir la liste.
  DateTime? readAt;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    this.type,
    this.title,
    this.message,
    this.taskId,
    this.projectId,
    this.actorName,
    this.readAt,
    required this.createdAt,
  });

  bool get isRead => readAt != null;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      type: json['type'],
      title: json['title'],
      message: json['message'],
      taskId: json['task_id'],
      projectId: json['project_id'],
      actorName: json['actor_name'],
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
