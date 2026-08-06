class Task {
  final int id;
  final int? projectId;
  final int? sprintId;
  final int? assignedToId;
  final int? createdById;

  final String? projectName;
  final String? sprintName;
  final String? assignedToName;

  final String title;
  final String? description;

  final String priority;
  final String status;

  final DateTime? deadline;

  final int? estimatedDurationMinutes;

  final DateTime? completedAt;

  final DateTime? recurrencePausedAt;

  final DateTime? recurrenceResumedAt;

  final DateTime? startedAt;

  final int? estimatedHours;

  final DateTime? timeExceededNotifiedAt;

  final DateTime? createdAt;

  final DateTime updatedAt;

  final DateTime? deletedAt;

  Task({
    required this.id,
    this.projectId,
    this.sprintId,
    this.assignedToId,
    this.createdById,
    this.projectName,
    this.sprintName,
    this.assignedToName,
    required this.title,
    this.description,
    required this.priority,
    required this.status,
    this.deadline,
    this.estimatedDurationMinutes,
    this.completedAt,
    this.recurrencePausedAt,
    this.recurrenceResumedAt,
    this.startedAt,
    this.estimatedHours,
    this.timeExceededNotifiedAt,
    this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      projectId: json['project_id'] ?? json['project']?['id'],
      sprintId: json['sprint_id'] ?? json['sprint']?['id'],
      assignedToId: json['assigned_to_id'] ?? json['assigned_to']?['id'],
      createdById: json['created_by_id'] ?? json['created_by']?['id'],
      projectName: json['project']?['name'],
      sprintName: json['sprint']?['name'],
      assignedToName: json['assigned_to']?['name'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      status: json['status'],
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      estimatedDurationMinutes: json['estimated_duration_minutes'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      recurrencePausedAt: json['recurrence_paused_at'] != null
          ? DateTime.parse(json['recurrence_paused_at'])
          : null,
      recurrenceResumedAt: json['recurrence_resumed_at'] != null
          ? DateTime.parse(json['recurrence_resumed_at'])
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      estimatedHours: json['estimated_hours'],
      timeExceededNotifiedAt: json['time_exceeded_notified_at'] != null
          ? DateTime.parse(json['time_exceeded_notified_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}