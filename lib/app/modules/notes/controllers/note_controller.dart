// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/exceptions/api_exception.dart';
import '../../../data/models/note_model.dart';
import '../../../data/providers/note_provider.dart';
import '../../../utils/helping_functions.dart';
import 'implementations/i_note_controller.dart';

/// Online mode: notes live on the server (REST API).
///
/// `allNotes` is the single source of truth. `notes` is the list currently on
/// screen (all notes, or only archived ones) and is rebuilt from `allNotes`
/// after every change, so create/update/delete/pin/archive can never leave the
/// two lists disagreeing.
class NoteController extends GetxController implements INoteController {
  @override
  final notes = <NoteModel>[].obs;
  @override
  final allNotes = <NoteModel>[].obs;
  final NoteProvider provider;
  @override
  final TextEditingController searchController = TextEditingController();
  @override
  SortType currentSortType = SortType.dateDesc;
  @override
  RxBool showArchived = false.obs;
  @override
  RxBool showDeleted = false.obs;

  NoteController({NoteProvider? provider})
    : provider = provider ?? NoteProvider();

  @override
  void onInit() {
    fetchNotes();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ---- list bookkeeping ---------------------------------------------------

  /// Rebuilds the visible list from [allNotes] (respecting the archive filter
  /// and the current sort order).
  void _refreshView() {
    if (showArchived.value) {
      notes.value = allNotes.where((n) => n.isArchived ?? false).toList();
    } else {
      notes.assignAll(allNotes);
    }
    sortNotes(currentSortType);
  }

  /// Puts [note] into [allNotes] (replacing the old copy, or adding it first).
  void _upsert(NoteModel note) {
    final index = allNotes.indexWhere((n) => n.id == note.id);
    if (index == -1) {
      allNotes.insert(0, note);
    } else {
      allNotes[index] = note;
    }
    _refreshView();
  }

  /// Runs an API call that returns the updated note; shows the server's error
  /// message when it fails.
  Future<void> _apply(Future<Response> request) async {
    final res = await request;
    final note = res.isOk ? NoteModel.fromEnvelope(res.body) : null;
    if (note != null) {
      _upsert(note);
    } else {
      showApiError(res);
    }
  }

  // ---- CRUD ----------------------------------------------------------------

  @override
  Future<void> fetchNotes() async {
    final response = await provider.getNotes();
    final fetched = response.isOk
        ? NoteModel.listFromEnvelope(response.body)
        : null;
    if (fetched != null) {
      allNotes.assignAll(fetched);
      _refreshView();
    } else {
      showApiError(response);
    }
  }

  @override
  Future<void> createNote(
    String title,
    String content,
    String color,
    bool isPinned,
  ) async {
    if (title.isEmpty && content.isEmpty) return;
    await _apply(
      provider.createNote({
        'title': title,
        'content': content,
        'color': normalizeHexColor(color),
        'status': 'draft',
        'is_pinned': isPinned,
      }),
    );
  }

  @override
  Future<void> updateNote(
    int id,
    String? title,
    String? content,
    String? color,
    bool? isPinned,
  ) async {
    if ((title?.isEmpty ?? true) && (content?.isEmpty ?? true)) return;
    await _apply(
      provider.updateNote(id, {
        'title': title,
        'content': content,
        'color': color != null ? normalizeHexColor(color) : null,
        'is_pinned': isPinned,
      }),
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    final res = await provider.deleteNote(id);
    if (res.isOk) {
      allNotes.removeWhere((n) => n.id == id);
      notes.removeWhere((n) => n.id == id);
    } else {
      showApiError(res);
    }
  }

  // ---- sorting / filtering -------------------------------------------------

  // Always sort pinned notes first, then by the chosen order.
  Comparator<NoteModel> _withPinnedFirst(Comparator<NoteModel> secondary) {
    return (a, b) {
      final aPinned = a.isPinned ?? false;
      final bPinned = b.isPinned ?? false;
      if (aPinned != bPinned) {
        return aPinned ? -1 : 1; // pinned on top
      }
      return secondary(a, b);
    };
  }

  final Comparator<NoteModel> _dateComparator = (a, b) {
    final aDate = a.createdAt ?? DateTime(0);
    final bDate = b.createdAt ?? DateTime(0);
    return bDate.compareTo(aDate); // newest first
  };

  final Comparator<NoteModel> _titleComparator = (a, b) =>
      a.title.toLowerCase().compareTo(b.title.toLowerCase());

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
    if (toggle) showArchived.value = true;
    _refreshView();
  }

  @override
  void unfilterAll() {
    showArchived.value = false;
    _refreshView();
  }

  // ---- per-note actions (each returns the updated note) ---------------------

  @override
  Future<void> pinNote(int id) => _apply(provider.pinNote(id));

  @override
  Future<void> unpinNote(int id) => _apply(provider.unpinNote(id));

  @override
  Future<void> archiveNote(int id) => _apply(provider.archiveNote(id));

  @override
  Future<void> unarchiveNote(int id) => _apply(provider.unarchiveNote(id));

  @override
  Future<void> markDeleted(int id) => _apply(provider.markDeleted(id));

  @override
  Future<void> addTags(int id, List<String> tags) =>
      _apply(provider.addTags(id, tags));

  @override
  Future<void> removeTags(int id, List<String> tags) =>
      _apply(provider.removeTags(id, tags));

  @override
  Future<void> changeColor(int id, String color) =>
      _apply(provider.changeColor(id, normalizeHexColor(color)));

  @override
  Future<void> changeStatus(int id, String status) =>
      _apply(provider.changeStatus(id, status));
}
