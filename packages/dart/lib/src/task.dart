class Task {
  // ===== 标识 =====
  final String id;
  final String title;
  final String description;

  // ===== 分类 =====
  final String? type;
  final String? category;
  final Map<String, String> tags;

  // ===== 状态 =====
  final String? status;
  final String? priority;

  // ===== 上下文 =====
  final String? assigner;
  final String? assignee;

  // ===== 计划 =====
  final DateTime? startAt;
  final DateTime? endAt;

  // ===== 审计 =====
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.type,
    this.category,
    this.tags = const {},
    this.status,
    this.priority,
    this.assigner,
    this.assignee,
    this.startAt,
    this.endAt,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(String key) {
      final v = json[key];
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      type: json['type'] as String?,
      category: json['category'] as String?,
      tags: json['tags'] is Map
          ? (json['tags'] as Map<String, dynamic>)
              .map((k, v) => MapEntry(k, v.toString()))
          : {},
      status: json['status'] as String?,
      priority: json['priority'] as String?,
      assigner: json['assigner'] as String?,
      assignee: json['assignee'] as String?,
      startAt: parseDateTime('startAt'),
      endAt: parseDateTime('endAt'),
      createdBy: json['createdBy'] as String?,
      createdAt: parseDateTime('createdAt'),
      updatedBy: json['updatedBy'] as String?,
      updatedAt: parseDateTime('updatedAt'),
    );
  }

  Task copyWith({
    String? type,
    String? category,
    String? status,
    String? priority,
    String? assigner,
    String? assignee,
    DateTime? startAt,
    DateTime? endAt,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      type: type ?? this.type,
      category: category ?? this.category,
      tags: tags,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assigner: assigner ?? this.assigner,
      assignee: assignee ?? this.assignee,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    String? formatDateTime(DateTime? dt) =>
        dt?.toIso8601String();

    final map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
    if (type != null) map['type'] = type;
    if (category != null) map['category'] = category;
    if (tags.isNotEmpty) map['tags'] = tags;
    if (status != null) map['status'] = status;
    if (priority != null) map['priority'] = priority;
    if (assigner != null) map['assigner'] = assigner;
    if (assignee != null) map['assignee'] = assignee;
    if (startAt != null) map['startAt'] = formatDateTime(startAt);
    if (endAt != null) map['endAt'] = formatDateTime(endAt);
    if (createdBy != null) map['createdBy'] = createdBy;
    if (createdAt != null) map['createdAt'] = formatDateTime(createdAt);
    if (updatedBy != null) map['updatedBy'] = updatedBy;
    if (updatedAt != null) map['updatedAt'] = formatDateTime(updatedAt);
    return map;
  }
}
