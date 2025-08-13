// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../data/models/note_model.dart';
import 'implementations/i_note_controller.dart';

class OfflineNoteController extends GetxController implements INoteController {
  @override
  final notes = <NoteModel>[].obs;
  @override
  final allNotes = <NoteModel>[].obs;
  @override
  final TextEditingController searchController = TextEditingController();
  @override
  SortType currentSortType = SortType.dateDesc;
  @override
  RxBool showArchived = false.obs;
  @override
  RxBool showDeleted = false.obs;

  late Box<NoteModel> _noteBox;

  @override
  Future<void> onInit() async {
    _noteBox = await Hive.openBox<NoteModel>('offline_notes');
    fetchNotes();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    _noteBox.close();
    super.onClose();
  }

  @override
  Future<void> fetchNotes() async {
    allNotes.assignAll(_noteBox.values.toList());
    notes.assignAll(allNotes);
    sortNotes(currentSortType);
    if (showArchived.value) filterOnlyArchived(false);
  }

  @override
  Future<void> createNote(
    String title,
    String content,
    String color,
    bool isPinned,
  ) async {
    if (title.isNotEmpty || content.isNotEmpty) {
      //Get.snackbar('Error', 'Title cannot be empty');
      // title = 'Untitled Note';

      final note = NoteModel(
        id: 0, // Hive will assign an ID later
        title: title,
        content: content,
        color: "#$color",
        isPinned: isPinned,
        status: 'draft',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final hiveKey = await _noteBox.add(note);
      final updatedNote = note.copyWith(id: hiveKey);
      await _noteBox.put(hiveKey, updatedNote);

      notes.insert(0, updatedNote);
      allNotes.insert(0, updatedNote);
      sortNotes(currentSortType);
    }
    //Get.snackbar('Success', 'Note created');
  }

  @override
  Future<void> updateNote(
    int id,
    String? title,
    String? content,
    String? color,
    bool? isPinned,
  ) async {
    if ((title?.isNotEmpty ?? false) || (content?.isNotEmpty ?? false)) {
      final note = _noteBox.get(id);
      if (note != null) {
        final updated = note.copyWith(
          title: title,
          content: content,
          color: color != null ? "#$color" : null,
          isPinned: isPinned,
          updatedAt: DateTime.now(),
        );
        await _noteBox.put(id, updated);
        _refreshNoteInMemory(id, updated);
        //Get.snackbar('Updated', 'Note updated successfully');
      }
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    await _noteBox.delete(id);
    notes.removeWhere((n) => n.id == id);
    allNotes.removeWhere((n) => n.id == id);
    //Get.snackbar('Deleted', 'Note deleted successfully');
  }

  void _refreshNoteInMemory(int id, NoteModel updated) {
    final index = allNotes.indexWhere((n) => n.id == id);
    if (index != -1) allNotes[index] = updated;
    final visibleIndex = notes.indexWhere((n) => n.id == id);
    if (visibleIndex != -1) notes[visibleIndex] = updated;
    sortNotes(currentSortType);
    notes.refresh();
  }

  Comparator<NoteModel> _withPinnedFirst(Comparator<NoteModel> secondary) {
    return (a, b) {
      final aPinned = a.isPinned ?? false;
      final bPinned = b.isPinned ?? false;
      if (aPinned != bPinned) return aPinned ? -1 : 1;
      return secondary(a, b);
    };
  }

  final Comparator<NoteModel> _dateComparator = (a, b) =>
      (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0));
  final Comparator<NoteModel> _titleComparator = (a, b) =>
      (a.title).toLowerCase().compareTo((b.title).toLowerCase());
  final Comparator<NoteModel> _colorComparator = (a, b) =>
      (a.color ?? '').compareTo(b.color ?? '');

  @override
  void sortNotes(SortType type) {
    currentSortType = type;
    switch (type) {
      case SortType.dateDesc:
        notes.sort(_withPinnedFirst(_dateComparator));
        break;
      case SortType.dateAsc:
        notes.sort(_withPinnedFirst((a, b) => _dateComparator(b, a)));
        break;
      case SortType.titleAsc:
        notes.sort(_withPinnedFirst(_titleComparator));
        break;
      case SortType.titleDesc:
        notes.sort(_withPinnedFirst((a, b) => _titleComparator(b, a)));
        break;
      case SortType.colorAsc:
        notes.sort(_withPinnedFirst(_colorComparator));
        break;
    }
    notes.refresh();
  }

  @override
  void filterOnlyArchived([bool toggle = true]) {
    if (showArchived.value && toggle) {
      unfilterAll();
      return;
    }
    notes.value = allNotes.where((note) => note.isArchived ?? false).toList();
    if (toggle) showArchived.value = true;
    sortNotes(currentSortType);
  }

  @override
  void unfilterAll() {
    notes.assignAll(allNotes);
    showArchived.value = false;
    sortNotes(currentSortType);
  }

  @override
  Future<void> pinNote(int id) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final updated = note.copyWith(isPinned: true, updatedAt: DateTime.now());
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Pinned', 'Note pinned successfully (offline)');
    }
  }

  @override
  Future<void> unpinNote(int id) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final updated = note.copyWith(isPinned: false, updatedAt: DateTime.now());
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Unpinned', 'Note unpinned successfully (offline)');
    }
  }

  @override
  Future<void> archiveNote(int id) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final updated = note.copyWith(
        isArchived: true,
        updatedAt: DateTime.now(),
      );
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Archived', 'Note archived successfully (offline)');
    }
  }

  @override
  Future<void> unarchiveNote(int id) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final updated = note.copyWith(
        isArchived: false,
        updatedAt: DateTime.now(),
      );
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      filterOnlyArchived(false);
      //Get.snackbar('Unarchived', 'Note unarchived successfully (offline)');
    }
  }

  @override
  Future<void> markDeleted(int id) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final updated = note.copyWith(isDeleted: true, updatedAt: DateTime.now());
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Deleted', 'Note marked as deleted (offline)');
    }
  }

  @override
  Future<void> changeColor(int id, String color) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final updated = note.copyWith(color: color, updatedAt: DateTime.now());
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Color Changed', 'Note color changed (offline)');
    }
  }

  @override
  Future<void> changeStatus(int id, String status) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final updated = note.copyWith(status: status, updatedAt: DateTime.now());
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Status Changed', 'Note status changed (offline)');
    }
  }

  @override
  Future<void> addTags(int id, List<String> newTags) async {
    final note = _noteBox.get(id);
    if (note != null) {
      final currentTags = note.tags ?? [];
      final updatedTags = {...currentTags, ...newTags}.toList();
      final updated = note.copyWith(
        tags: updatedTags,
        updatedAt: DateTime.now(),
      );
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Tags Added', 'Tags added (offline)');
    }
  }

  @override
  Future<void> removeTags(int id, List<String> tagsToRemove) async {
    final note = _noteBox.get(id);
    if (note != null && note.tags != null) {
      final updatedTags = (note.tags ?? [])
          .where((tag) => !tagsToRemove.contains(tag))
          .toList();
      final updated = note.copyWith(
        tags: updatedTags,
        updatedAt: DateTime.now(),
      );
      await _noteBox.put(id, updated);
      _refreshNoteInMemory(id, updated);
      //Get.snackbar('Tags Removed', 'Tags removed (offline)');
    }
  }
}
