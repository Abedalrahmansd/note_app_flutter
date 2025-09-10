import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/theme_controller.dart';
import '../../../data/models/note_model.dart';
import '../../../data/helpers/custom_navigation.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/implementations/i_note_controller.dart';
import 'widgets/delete_dialog.dart';

class NotesPage extends GetView<INoteController> {
  final _scrollController = ScrollController();
  final RxString _searchQuery = ''.obs;
  // final _debouncer = Debouncer(milliseconds: 300);
  final FocusNode _searchFocusNode = FocusNode();

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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => openNoteEditPage(null),
              backgroundColor: AppPalette.primary,
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.black, size: 24),
              label: const Text(
                "New Note",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, _) => [
                _buildHeader(themeController, theme),
              ],
              body: Column(
                children: [
                  _buildSearchBar(theme),
                  Expanded(child: _buildNotesList(theme)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // HEADER / APPBAR
  SliverAppBar _buildHeader(ThemeController themeController, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      floating: true,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isExpanded = constraints.maxHeight > 100;
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
            title: Obx(
              () => Text(
                _searchQuery.value.isEmpty
                    ? controller.showArchived.value
                          ? 'Archived Notes (${controller.notes.length})'
                          : 'Notes (${controller.notes.length})'
                    : 'Searching...',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: isExpanded ? 22 : 18,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.primary,
                ),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.appBarTheme.backgroundColor!,
                    AppPalette.primary.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                  : themeController.themeMode.value == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.brightness_auto,
              color: AppPalette.primary,
            ),
          ),
          onPressed: themeController.toggleTheme,
        ),
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
          onPressed: () => _showSortOptions(Get.context!),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: AppPalette.primary),
          onPressed: () => Get.find<AuthController>().logout(),
        ),
      ],
    );
  }

  // SEARCH BAR
  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: TextField(
        controller: controller.searchController,
        focusNode: _searchFocusNode,
        onChanged: (value) => _searchQuery.value = value,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor,
          prefixIcon: Icon(Icons.search, color: theme.hintColor),
          hintText: 'Search notes...',
          hintStyle: TextStyle(color: theme.hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // NOTES LIST
  Widget _buildNotesList(ThemeData theme) {
    return Obx(() {
      final filteredNotes = controller.notes.where((note) {
        if ((note.isArchived ?? false) && !controller.showArchived.value) {
          return false;
        }
        if ((note.isDeleted ?? false) && !controller.showDeleted.value) {
          return false;
        }
        if (_searchQuery.value.isEmpty) return true;
        final query = _searchQuery.value.toLowerCase();
        return note.title.toLowerCase().contains(query) ||
            (note.content ?? '').toLowerCase().contains(query);
      }).toList();

      if (filteredNotes.isEmpty) return _buildEmptyState(theme);

      return RefreshIndicator(
        onRefresh: controller.fetchNotes,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(Get.context!).size.width >= 700
                ? 4
                : 2,
            mainAxisExtent: 180,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            return _buildNoteCard(filteredNotes[index], theme);
          },
        ),
      );
    });
  }

  // EMPTY STATE
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 72, color: theme.hintColor),
            const SizedBox(height: 12),
            Text(
              _searchQuery.value.isEmpty
                  ? (controller.showArchived.value
                        ? 'No Archived Notes'
                        : 'No Notes Yet')
                  : 'No Matches Found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.value.isEmpty
                  ? (controller.showArchived.value
                        ? 'Hold a note to archive/unarchive'
                        : 'Tap + to create your first note')
                  : 'Try a different keyword',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NOTE CARD
  Widget _buildNoteCard(NoteModel note, ThemeData theme) {
    final cardColor = _getNoteColor(note);
    final textColor = cardColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return GestureDetector(
      onTap: () => openNoteEditPage(note),
      onDoubleTap: () => (note.isPinned ?? false)
          ? controller.unpinNote(note.id)
          : controller.pinNote(note.id),
      onLongPress: () async {
        final isArch = note.isArchived ?? false;
        final result = await Get.dialog(
          ConfirmationDialog(
            theme: theme,
            title: isArch ? 'Unarchive Note' : 'Archive Note',
            description: isArch
                ? 'Are you sure you want to unarchive this note?'
                : 'Are you sure you want to archive this note?',
            confirmButtonBackgroundColor: AppPalette.primary,
            confirmText: isArch ? 'Unarchive' : 'Archive',
          ),
        );
        if (result ?? false) {
          isArch
              ? controller.unarchiveNote(note.id)
              : controller.archiveNote(note.id);
        }
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
        onDismissed: (_) => _deleteNote(note),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.title.isNotEmpty)
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  note.content ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.85),
                    height: 1.35,
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
                    Icon(Icons.push_pin, size: 16, color: textColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HELPERS
  Color _getNoteColor(NoteModel note) {
    try {
      return note.color != null && note.color!.isNotEmpty
          ? HexColor(note.color!)
          : (Get.isDarkMode ? AppPalette.cardDark : AppPalette.cardLight);
    } catch (_) {
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
              const SizedBox(height: 20),
              _buildSortOption(
                'Date Created (Newest First)',
                Icons.access_time,
                () => controller.sortNotes(SortType.dateDesc),
              ),
              _buildSortOption(
                'Date Created (Oldest First)',
                Icons.access_time,
                () => controller.sortNotes(SortType.dateAsc),
              ),
              _buildSortOption(
                'Title (A-Z)',
                Icons.sort_by_alpha,
                () => controller.sortNotes(SortType.titleAsc),
              ),
              _buildSortOption(
                'Title (Z-A)',
                Icons.sort_by_alpha,
                () => controller.sortNotes(SortType.titleDesc),
              ),
              _buildSortOption(
                'Color',
                Icons.color_lens,
                () => controller.sortNotes(SortType.colorAsc),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppPalette.primary),
      title: Text(title),
      onTap: () {
        onTap();
        Get.back();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

/* class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
 */
