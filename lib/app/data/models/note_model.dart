class NoteModel {
  final int id;
  final String title;
  final String? content;
  final String? color;
  final bool? isPinned;
  final bool? isArchived;
  final bool? isDeleted;
  final String? category;
  final String? tags;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    this.content,
    this.color,
    this.isPinned,
    this.isArchived,
    this.isDeleted,
    this.category,
    this.tags,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    color: json['color'],
    isPinned: json['is_pinned'],
    isArchived: json['is_archived'],
    isDeleted: json['is_deleted'],
    category: json['category'],
    tags: json['tags'],
    status: json['status'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'color': color,
    'is_pinned': isPinned,
    'is_archived': isArchived,
    'is_deleted': isDeleted,
    'category': category,
    'tags': tags,
    'status': status,
  };
}
