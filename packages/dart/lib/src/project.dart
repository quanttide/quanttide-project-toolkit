class Project {
  // ===== 标识 =====
  final String id;
  final String name;
  final String title;
  final String description;

  // ===== 审计 =====
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.title,
    this.description = '',
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(String key) {
      final v = json[key];
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      createdBy: json['createdBy'] as String?,
      createdAt: parseDateTime('createdAt'),
      updatedBy: json['updatedBy'] as String?,
      updatedAt: parseDateTime('updatedAt'),
    );
  }

  Map<String, dynamic> toJson() {
    String? formatDateTime(DateTime? dt) =>
        dt?.toIso8601String();

    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'title': title,
      'description': description,
    };
    if (createdBy != null) map['createdBy'] = createdBy;
    if (createdAt != null) map['createdAt'] = formatDateTime(createdAt);
    if (updatedBy != null) map['updatedBy'] = updatedBy;
    if (updatedAt != null) map['updatedAt'] = formatDateTime(updatedAt);
    return map;
  }
}
