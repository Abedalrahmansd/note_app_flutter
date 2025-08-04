import 'package:hive/hive.dart';

part 'note_model.g.dart'; // Required for generated adapter

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? content;

  @HiveField(3)
  String? color;

  @HiveField(4)
  bool? isPinned;

  @HiveField(5)
  bool? isArchived;

  @HiveField(6)
  bool? isDeleted;

  @HiveField(7)
  String? category;

  @HiveField(8)
  List<String>? tags;

  @HiveField(9)
  String? status;

  @HiveField(10)
  DateTime? createdAt;

  @HiveField(11)
  DateTime? updatedAt;

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
    tags: json['tags'] != null
        ? (json['tags'] as String).split(',').map((e) => e.trim()).toList()
        : [],
    status: json['status'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
  );

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    String? color,
    bool? isPinned,
    bool? isArchived,
    bool? isDeleted,
    String? category,
    List<String>? tags,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'color': color,
    'is_pinned': isPinned,
    'is_archived': isArchived,
    'is_deleted': isDeleted,
    'category': category,
    'tags': tags?.join(','),
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
