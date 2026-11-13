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
  /// Parses one note from the API. Tolerant on purpose: MySQL/Laravel often
  /// sends booleans as 0/1 and ids as strings, and tags as a comma string or a list.
  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
    id: _asInt(json['id']),
    title: (json['title'] ?? '').toString(),
    content: json['content']?.toString(),
    color: json['color']?.toString(),
    isPinned: _asBool(json['is_pinned']),
    isArchived: _asBool(json['is_archived']),
    isDeleted: _asBool(json['is_deleted']),
    category: json['category']?.toString(),
    tags: _asTags(json['tags']),
    status: json['status']?.toString(),
    createdAt: _asDate(json['created_at']),
    updatedAt: _asDate(json['updated_at']),
  );

  /// Reads `{ "data": { ...note... } }` (what the API returns for one note).
  /// Returns null for anything else, e.g. an error body.
  static NoteModel? fromEnvelope(dynamic body) {
    if (body is Map && body['data'] is Map) {
      return NoteModel.fromJson(Map<String, dynamic>.from(body['data'] as Map));
    }
    return null;
  }

  /// Reads `{ "data": [ ...notes... ] }`. Returns null for anything else.
  static List<NoteModel>? listFromEnvelope(dynamic body) {
    if (body is Map && body['data'] is List) {
      return (body['data'] as List)
          .whereType<Map>()
          .map((e) => NoteModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return null;
  }

  static int _asInt(dynamic v) => v is int ? v : int.parse(v.toString());

  static bool? _asBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v.toString().toLowerCase();
    return s == 'true' || s == '1';
  }

  static List<String> _asTags(dynamic v) {
    if (v == null) return [];
    final parts = v is List ? v.map((e) => e.toString()) : v.toString().split(',');
    return parts.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  static DateTime? _asDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

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
