class Project {
  final int id;
  final String name;
  final String? client;
  final String? status;

  Project({
    required this.id,
    required this.name,
    this.client,
    this.status,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      client: json['client'],
      status: json['status'],
    );
  }
}

class ProjectMember {
  final int id;
  final String name;
  final String? role;

  ProjectMember({
    required this.id,
    required this.name,
    this.role,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}
