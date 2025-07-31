class NoteModel {
  final int id;
  final String title;
  final String? content;
  final String color;
  final bool isPinned;
  final bool isArchived;
  final bool isDeleted;
  final String? category;
  final String? tags;
  final String status;

  NoteModel({
    required this.id,
    required this.title,
    this.content,
    required this.color,
    required this.isPinned,
    required this.isArchived,
    required this.isDeleted,
    this.category,
    this.tags,
    required this.status,
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