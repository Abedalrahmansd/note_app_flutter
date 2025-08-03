import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/app/data/models/note_model.dart';
import 'package:note_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:note_app/app/modules/notes/views/widgets/delete_dialog.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/theme_controller.dart';
import '../controllers/note_controller.dart';
import 'package:hexcolor/hexcolor.dart';

class NotesPage extends GetView<NoteController> {
  final _scrollController = ScrollController();
  final RxString _searchQuery = ''.obs;
  final _debouncer = Debouncer(milliseconds: 300);

  NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final theme = themeController.currentTheme.value;

      return Theme(
        data: theme,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showNoteForm(context),
              backgroundColor: AppPalette.primary,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 28),
            ),
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  floating: true,
                  elevation: 0,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final isExpanded = constraints.maxHeight > 100;
                      return FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(
                          left: 16,
                          bottom: isExpanded ? 16 : 10,
                        ),
                        title: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _searchQuery.value.isEmpty
                                ? 'Notes'
                                // 'Notes (${controller.notes.length})'
                                : 'Searching...',
                            key: ValueKey(
                              '${_searchQuery.value}_${theme.hashCode}',
                            ),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: isExpanded ? 22 : 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                theme.appBarTheme.backgroundColor!,
                                theme.appBarTheme.backgroundColor!.withOpacity(
                                  0.7,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Obx(
                        () => Icon(
                          themeController.themeMode.value == ThemeMode.dark
                              ? Icons.dark_mode
                              : themeController.themeMode.value ==
                                    ThemeMode.light
                              ? Icons.light_mode
                              : Icons.brightness_auto,
                          color: AppPalette.primary,
                        ),
                      ),
                      onPressed: themeController.toggleTheme,
                    ),
                    //show only archieved
                    Obx(
                      () => IconButton(
                        onPressed: () => controller.filterOnlyArchived(),
                        icon: Icon(
                          controller.showArchived.value
                              ? Icons.archive
                              : Icons.archive_outlined,
                          color: AppPalette.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.sort, color: AppPalette.primary),
                      onPressed: () => _showSortOptions(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: AppPalette.primary),
                      onPressed: () {
                        Get.find<AuthController>().logout();
                      },
                    ),
                  ],
                ),
              ],
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: (value) =>
                          _debouncer.run(() => _searchQuery.value = value),
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        prefixIcon: Icon(Icons.search, color: theme.hintColor),
                        hintText: 'Search notes...',
                        hintStyle: TextStyle(color: theme.hintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: _buildNotesList(theme)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNotesList(ThemeData theme) {
    return Obx(() {
      final filteredNotes = controller.notes.where((note) {
        //reversed if needed
        //archieved notes
        if ((note.isArchived ?? false) && !controller.showArchived.value)
          return false;
        if ((note.isDeleted ?? false) && !controller.showDeleted.value)
          return false;
        if (_searchQuery.value.isEmpty) return true;
        final query = _searchQuery.value.toLowerCase();
        return (note.title?.toLowerCase().contains(query) ?? false) ||
            (note.content ?? '').toLowerCase().contains(query);
      }).toList();

      if (filteredNotes.isEmpty) {
        return _buildEmptyState(theme);
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.fetchNotes();
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(Get.context!).size.width >= 700
                ? 4
                : 2,
            mainAxisExtent:
                MediaQuery.of(Get.context!).size.height *
                0.3, //additional for `andriod`
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            final note = filteredNotes[index];
            /* if (note.isDeleted ?? false)
              return SizedBox.shrink(); // Skip deleted notes
            if (note.isArchived ?? false)
              return SizedBox.shrink(); // Skip archived notes */
            return _buildNoteCard(note, theme);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add_outlined, size: 64, color: theme.hintColor),
          const SizedBox(height: 16),
          Text(
            _searchQuery.value.isEmpty
                ? (controller.showArchived.value
                      ? 'Nothing Archived'
                      : 'No notes yet')
                : 'No matches found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.value.isEmpty
                ? (controller.showArchived.value
                      ? 'Archive a note by holding it'
                      : 'Tap + to create your first note')
                : 'Try a different search term',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(NoteModel note, ThemeData theme) {
    final cardColor = _getNoteColor(note);
    final textColor = cardColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return GestureDetector(
      onTap: () => _showNoteForm(Get.context!, note: note),
      onDoubleTap: () {
        if (note.isPinned ?? false) {
          controller.unpinNote(note.id);
        } else {
          controller.pinNote(note.id);
        }
      },
      onLongPress: () async {
        bool? result;
        if (note.isArchived ?? false) {
          result = await Get.dialog(
            ConfirmationDialog(
              theme: theme,
              title: 'Unarchive Note',
              description: 'Are you sure you want to unarchive this note?',
              confirmButtonBackgroundColor: AppPalette.primary,
              confirmText: 'Unarchive',
            ),
          );
          if (result ?? false) controller.unarchiveNote(note.id);
          return;
        }
        result = await Get.dialog(
          ConfirmationDialog(
            theme: theme,
            title: 'Archive Note',
            description: 'Are you sure you want to archive this note?',
            confirmButtonBackgroundColor: AppPalette.primary,
            confirmText: 'Archive',
          ),
        );
        if (result ?? false) controller.archiveNote(note.id);
        return;

        //archive Note
      },
      child: Dismissible(
        key: Key(note.id.toString()),
        direction: DismissDirection.endToStart,

        confirmDismiss: (direction) async {
          return await Get.dialog(
            ConfirmationDialog(
              theme: theme,
              title: 'Delete Note',
              description: 'Are you sure you want to delete this note?',
              confirmButtonBackgroundColor: AppPalette.deleteRed,
              confirmText: 'Delete',
            ),

            // barrierDismissible: false,
          );
        },
        background: Container(
          decoration: BoxDecoration(
            color: AppPalette.deleteRed,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (direction) => _deleteNote(note),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.title?.isNotEmpty ?? false) ...[
                      Text(
                        note.title!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                    Expanded(
                      child: Text(
                        note.content ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.9),
                          height: 1.4,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          note.createdAt != null
                              ? '${note.createdAt!.day}/${note.createdAt!.month}/${note.createdAt!.year}'
                              : '',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                        if (note.isPinned ?? false)
                          const Icon(
                            Icons.push_pin,
                            size: 16,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNoteColor(NoteModel note) {
    try {
      return note.color != null && note.color!.isNotEmpty
          ? HexColor(note.color!)
          : (Get.isDarkMode ? AppPalette.cardDark : AppPalette.cardLight);
    } catch (e) {
      return Get.isDarkMode ? AppPalette.cardDark : AppPalette.cardLight;
    }
  }

  void _deleteNote(NoteModel note) {
    controller.deleteNote(note.id);
    Get.showSnackbar(
      GetSnackBar(
        message: 'Note moved to trash',
        duration: const Duration(seconds: 2),
        backgroundColor: AppPalette.deleteRed,
        borderRadius: 8,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  void _showNoteForm(BuildContext context, {NoteModel? note}) {
    final titleController = TextEditingController(text: note?.title);
    final contentController = TextEditingController(text: note?.content);
    final RxString colorController =
        (note?.color ?? (Get.isDarkMode ? '2C2C2C' : 'ffffff')).obs;
    final RxBool isPinned = (note?.isPinned ?? false).obs;
    final isEditing = note != null;

    final List<Map<String, dynamic>> colorOptions = AppPalette.noteColors;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.bottomSheetTheme.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Get.theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEditing ? 'Edit Note' : 'New Note',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                style: Get.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: AppPalette.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Get.theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppPalette.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 5,
                style: Get.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: "Content",
                  labelStyle: TextStyle(color: AppPalette.primary),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Get.theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppPalette.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text('Note Color', style: Get.textTheme.bodyLarge),
                  const Spacer(),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(colorController.value),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: HexColor(colorController.value),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: colorOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final color = colorOptions[index];
                    return Obx(() {
                      final selected = colorController.value == color['color'];
                      return GestureDetector(
                        onTap: () => colorController.value = color['color'],
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: selected ? 48 : 40,
                          height: selected ? 48 : 40,
                          decoration: BoxDecoration(
                            color: HexColor(color['color']),
                            shape: BoxShape.circle,
                            border: selected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: selected ? 8 : 1,
                                spreadRadius: selected ? 1 : 0.25,
                              ),
                            ],
                          ),
                          child: selected
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Obx(
                    () => Switch(
                      value: isPinned.value,
                      activeColor: AppPalette.primary,
                      onChanged: (val) => isPinned.value = val,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Pin this note', style: Get.textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Get.theme.dividerColor),
                      ),
                      child: Text('Cancel', style: Get.textTheme.bodyLarge),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          controller.updateNote(
                            note.id,
                            titleController.text,
                            contentController.text,
                            colorController.value,
                            isPinned.value,
                          );
                        } else {
                          controller.createNote(
                            titleController.text,
                            contentController.text,
                            colorController.value,
                            isPinned.value,
                          );
                        }
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Update' : 'Create',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  void _showSortOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.bottomSheetTheme.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sort Notes By',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSortOption(
                  'Date Created (Newest First)',
                  Icons.access_time,
                  () {
                    controller.sortNotes(SortType.dateDesc);
                    Get.back();
                  },
                ),
                _buildSortOption(
                  'Date Created (Oldest First)',
                  Icons.access_time,
                  () {
                    controller.sortNotes(SortType.dateAsc);
                    Get.back();
                  },
                ),
                _buildSortOption('Title (A-Z)', Icons.sort_by_alpha, () {
                  controller.sortNotes(SortType.titleAsc);
                  Get.back();
                }),
                _buildSortOption('Title (Z-A)', Icons.sort_by_alpha, () {
                  controller.sortNotes(SortType.titleDesc);
                  Get.back();
                }),
                _buildSortOption('Color', Icons.color_lens, () {
                  controller.sortNotes(SortType.colorAsc);
                  Get.back();
                }),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Get.theme.colorScheme.onSurface,
                    side: BorderSide(color: Get.theme.dividerColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSortOption(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppPalette.primary),
        title: Text(title, style: Get.textTheme.bodyLarge),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Get.theme.cardColor,
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
