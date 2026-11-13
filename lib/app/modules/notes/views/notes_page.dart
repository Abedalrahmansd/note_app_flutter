import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/theme_controller.dart';
import '../../../data/models/note_model.dart';
import '../../../data/helpers/custom_navigation.dart';
import '../controllers/implementations/i_note_controller.dart';
import 'widgets/delete_dialog.dart';
import 'package:typeset/typeset.dart';

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
              label: Text(
                'Note->Add_Note'.tr,
                style: const TextStyle(
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
          // final isExpanded = constraints.maxHeight > 100;
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(
              right: 16,
              left: 16,
              bottom: 12,
            ),
            title: Obx(
              () => Text(
                _searchQuery.value.isEmpty
                    ? controller.showArchived.value
                          ? "${'Note->Archived_Title'.tr} (${controller.notes.length})"
                          : "${'Note->Title'.tr} (${controller.notes.length})"
                    : 'Search->Title_Text'.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  // fontSize: isExpanded ? 22 : 18,
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
        /* IconButton(
          icon: const Icon(Icons.logout, color: AppPalette.primary),
          onPressed: () async {
            final result = await Get.dialog(
              ConfirmationDialog(
                theme: theme,
                title: 'تسجيل الخروج',
                description: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                confirmButtonBackgroundColor: AppPalette.errorRed,
                confirmText: 'تسجيل الخروج',
              ),
            );
            if (result ?? false) {
              Get.find<AuthController>().logout();
            }
          },
        ), */
        IconButton(
          icon: const Icon(Icons.settings, color: AppPalette.primary),
          onPressed: () {
            // Open settings page
            CustomNavigation.navigateToSettingsPage();
          },
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
          hintText: 'Search->Hint'.tr,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
          ),
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

      if (filteredNotes.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16),

          child: _buildEmptyState(theme),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchNotes,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                // make it responsive
                MediaQuery.of(Get.context!).size.width >= 1000
                ? 4
                : MediaQuery.of(Get.context!).size.width >= 600
                ? 3
                : 2,
            // MediaQuery.of(Get.context!).size.width >= 700? 4: 2,
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
                        ? 'Note->Archive_Empty_Title'.tr
                        : 'Note->No_Notes_Title'.tr)
                  : 'Search->No_Results_Title'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.value.isEmpty
                  ? (controller.showArchived.value
                        ? 'Note->Archive_Guide_Text'.tr
                        : 'Note->Guide_Text'.tr)
                  : 'Search->No_Results_Subtitle'.tr,
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
    final cardBgColor = _getNoteBgColor();
    bool isColorBorder = false;
    final textColor =
        (isColorBorder ? cardBgColor : cardColor).computeLuminance() > 0.5
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
            title: isArch ? 'Note->Unarchive_Note'.tr : 'Note->Archive_Note'.tr,
            description: isArch
                ? 'Note->Unarchive_Confirm_Title'.tr
                : 'Note->Archive_Confirm_Title'.tr,
            confirmButtonBackgroundColor: AppPalette.primary,
            confirmText: isArch ? 'Note->Cancel'.tr : 'Global->Confirm'.tr,
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
              title: 'Note->Delete_Note'.tr,
              description: 'Note->Delete_Confirm_Title'.tr,
              confirmButtonBackgroundColor: AppPalette.errorRed,
              confirmText: 'Global->Confirm'.tr,
            ),
          );
        },
        background: Container(
          decoration: BoxDecoration(
            color: AppPalette.errorRed,
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
            color: isColorBorder ? cardBgColor : cardColor,
            borderRadius: BorderRadius.circular(16),
            border: isColorBorder
                ? Border.all(color: cardColor, width: 1)
                : null,
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    // fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 6),
              Expanded(
                child: TypeSet(
                  note.content ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    // fontSize: 14,
                    color: textColor.withOpacity(0.85),
                    height: 1.35,
                  ),
                  // maxLines: 5,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    note.createdAt != null
                        ? '${note.createdAt!.day}/${note.createdAt!.month}/${note.createdAt!.year}'
                        : '',
                    style: TextStyle(
                      fontSize: 8,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  if (note.isPinned ?? false)
                    Icon(Icons.push_pin, size: 8, color: textColor),
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

  Color _getNoteBgColor() {
    return (Get.isDarkMode ? AppPalette.cardDark : AppPalette.cardLight);
  }

  void _deleteNote(NoteModel note) {
    controller.deleteNote(note.id);
    Get.showSnackbar(
      GetSnackBar(
        message: 'Snackbar->Note_Deleted_Text'.tr,
        duration: const Duration(seconds: 2),
        backgroundColor: AppPalette.errorRed,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Note->Sort_Options_Title'.tr,
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSortOption(
                  'Note->Sort_Options_Date_Desc'.tr,
                  Icons.access_time,
                  () => controller.sortNotes(SortType.dateDesc),
                ),
                _buildSortOption(
                  'Note->Sort_Options_Date_Asc'.tr,
                  Icons.access_time,
                  () => controller.sortNotes(SortType.dateAsc),
                ),
                _buildSortOption(
                  'Note->Sort_Options_Title_Asc'.tr,
                  Icons.sort_by_alpha,
                  () => controller.sortNotes(SortType.titleAsc),
                ),
                _buildSortOption(
                  'Note->Sort_Options_Title_Desc'.tr,
                  Icons.sort_by_alpha,
                  () => controller.sortNotes(SortType.titleDesc),
                ),
                _buildSortOption(
                  'Note->Sort_Options_Color_Asc'.tr,
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
                  child: Text('Global->Cancel'.tr),
                ),
              ],
            ),
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
