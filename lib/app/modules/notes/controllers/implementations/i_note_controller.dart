import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/models/note_model.dart';

abstract class INoteController {
  RxList<NoteModel> get notes;
  RxList<NoteModel> get allNotes;

  SortType get currentSortType;
  set currentSortType(SortType type);

  RxBool get showArchived;
  RxBool get showDeleted;

  TextEditingController get searchController;

  Future<void> fetchNotes();
  Future<void> createNote(
    String title,
    String content,
    String color,
    bool isPinned,
  );
  Future<void> updateNote(
    int id,
    String? title,
    String? content,
    String? color,
    bool? isPinned,
  );
  Future<void> deleteNote(int id);

  void sortNotes(SortType type);
  void filterOnlyArchived([bool toggle = true]);
  void unfilterAll();

  Future<void> pinNote(int id);
  Future<void> unpinNote(int id);
  Future<void> archiveNote(int id);
  Future<void> unarchiveNote(int id);
  Future<void> markDeleted(int id);
  Future<void> changeColor(int id, String color);
  Future<void> changeStatus(int id, String status);
  Future<void> addTags(int id, List<String> tags);
  Future<void> removeTags(int id, List<String> tags);
}

enum SortType { dateDesc, dateAsc, titleAsc, titleDesc, colorAsc }
