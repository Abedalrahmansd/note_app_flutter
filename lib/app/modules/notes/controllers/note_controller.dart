import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/note_model.dart';
import '../../../data/providers/note_provider.dart';

class NoteController extends GetxController {
  final notes = <NoteModel>[].obs;
  final provider = NoteProvider();
  final TextEditingController searchController = TextEditingController();
  SortType currentSortType = SortType.dateDesc;

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
  

  // Extension to convert Color to hex string

  void fetchNotes() async {
    final response = await provider.getNotes();
    if (response.isOk) {
      notes.assignAll(response.body ?? []);
      sortNotes(SortType.dateDesc);
    }
  }

  void createNote(
    String title,
    String content,
    String color,
    bool isPinned,
  ) async {
    // print("Creating note with title: $title, content: $content, color: $color");
    // return;
    if (title.isEmpty) {
      Get.snackbar('Error', 'Title cannot be empty');
      return;
    }
    final body = {
      'title': title,
      'content': content,
      'color': "#$color", // Assuming color is a hex string
      'status': 'draft',
      // Optional fields:
      'is_pinned': isPinned,
      // 'is_archived': false,
      // 'is_deleted': false,
      // 'category': null,
      // 'tags': null,
    };

    final response = await provider.createNote(body);

    if (response.isOk && response.body != null) {
      notes.insert(0, response.body!); // update UI
      sortNotes(currentSortType);
      Get.snackbar('Success', 'Note created');
    } else {
      Get.snackbar('Error', 'Failed to create note');
    }
  }

  void updateNote(
    int id,
    String title,
    String content,
    String color,
    bool isPinned,
  ) async {
    final body = {
      'title': title,
      'content': content,
      'color': "#$color", // Assuming color is a hex string
      'is_pinned': isPinned,
      // 'status': 'draft', // or 'published', etc.
    };

    final res = await provider.updateNote(id, body);
    if (res.isOk && res.body != null) {
      final index = notes.indexWhere((n) => n.id == id);
      if (index != -1) notes[index] = res.body!;
      notes.refresh();
      sortNotes(currentSortType);
      Get.snackbar('Updated', 'Note updated successfully');
    } else {
      Get.snackbar('Error', 'Failed to update note');
    }
  }

  void deleteNote(int id) async {
    final res = await provider.deleteNote(id);
    if (res.isOk) {
      notes.removeWhere((n) => n.id == id);
      Get.snackbar('Deleted', 'Note deleted successfully');
    } else {
      Get.snackbar('Error', 'Failed to delete note');
    }
  }

  // Helper: Always sort pinned notes first, then by provided comparator
  Comparator<NoteModel> _withPinnedFirst(Comparator<NoteModel> secondary) {
    return (a, b) {
      final aPinned = a.isPinned ?? false;
      final bPinned = b.isPinned ?? false;
      if (aPinned != bPinned)
        return aPinned ? -1 : 1; // true first (pinned on top)
      return secondary(a, b);
    };
  }

  // Comparators for secondary sorting
  final Comparator<NoteModel> _dateComparator = (a, b) {
    final aDate = a.createdAt ?? DateTime(0);
    final bDate = b.createdAt ?? DateTime(0);
    return bDate.compareTo(aDate); // Newest first
  };

  final Comparator<NoteModel> _titleComparator = (a, b) {
    final aTitle = (a.title ?? '').toLowerCase();
    final bTitle = (b.title ?? '').toLowerCase();
    return aTitle.compareTo(bTitle);
  };

  final Comparator<NoteModel> _colorComparator = (a, b) {
    final aColor = a.color ?? '';
    final bColor = b.color ?? '';
    return aColor.compareTo(bColor);
  };

  void sortNotes(SortType type) {
    switch (type) {
      case SortType.dateDesc:
        currentSortType = SortType.dateDesc;
        notes.sort(_withPinnedFirst(_dateComparator));
        break;
      case SortType.dateAsc:
        currentSortType = SortType.dateAsc;
        notes.sort(
          _withPinnedFirst((a, b) => _dateComparator(b, a)),
        ); // Oldest first
        break;
      case SortType.titleAsc:
        currentSortType = SortType.titleAsc;
        notes.sort(_withPinnedFirst(_titleComparator));
        break;
      case SortType.titleDesc:
        currentSortType = SortType.titleDesc;
        notes.sort(_withPinnedFirst((a, b) => _titleComparator(b, a)));
        break;
      case SortType.colorAsc:
        currentSortType = SortType.colorAsc;
        notes.sort(_withPinnedFirst(_colorComparator));
        break;
      default:
        currentSortType = SortType.dateAsc;
        notes.sort(_withPinnedFirst(_dateComparator));
        break;
    }
    notes.refresh();
  }

  
}

enum SortType { dateDesc, dateAsc, titleAsc, titleDesc, colorAsc }
