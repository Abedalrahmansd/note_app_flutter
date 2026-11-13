import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/app/data/helpers/lang_helpers.dart';
import 'package:notes_app/app/modules/notes/controllers/implementations/i_note_controller.dart';
import 'package:notes_app/theme/theme_controller.dart';
import 'package:typeset/typeset.dart';
import '../../../../theme/app_theme.dart';
import '../../../data/models/note_model.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../utils/helping_functions.dart';

class NoteEditPage extends StatefulWidget {
  final NoteModel? note;

  const NoteEditPage({Key? key, this.note}) : super(key: key);

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedColor;
  late final String _initialColor;
  late bool _isPinned;
  final _focusNode = FocusNode();
  final themeController = Get.find<ThemeController>();
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = themeController.currentTheme.value;
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TypeSetEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedColor =
        widget.note?.color ??
        (themeController.currentTheme.value == AppTheme.darkTheme
            ? AppPalette.noteColors
                  .where((c) => c['name'] == 'Midnight Black')
                  .first['color']
            : AppPalette.noteColors
                  .where((c) => c['name'] == 'Classic White')
                  .first['color']);
    _isPinned = widget.note?.isPinned ?? false;
    // Notes from the API/Hive carry '#RRGGBB'; the colour picker uses 'RRGGBB'.
    _selectedColor = hexWithoutHash(_selectedColor);
    _initialColor = _selectedColor;

    // Auto-focus content field if no title
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.note == null) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    final List<Map<String, dynamic>> colorOptions = AppPalette.noteColors;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: HexColor(_selectedColor),
        appBar: _buildAppBar(context, isEditing),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        textDirection: autoTextDirection(_titleController.text),
                        controller: _titleController,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          // fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: _getContrastColor(HexColor(_selectedColor)),
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: 'Note->New->Title'.tr,
                          hintStyle: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _getContrastColor(
                              HexColor(_selectedColor),
                            ).withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.only(bottom: 12),
                        ),
                        maxLines: 1,
                      ),
                      // const SizedBox(height: 8),
                      TextField(
                        textDirection: autoTextDirection(
                          _contentController.text,
                        ),
                        onChanged: (value) => setState(() {}),
                        controller: _contentController,
                        contextMenuBuilder: (context, editableTextState) {
                          return AdaptiveTextSelectionToolbar.buttonItems(
                            anchors: editableTextState.contextMenuAnchors,
                            buttonItems: [
                              // Add TypeSet formatting options to the context menu
                              ...getTypesetContextMenus(
                                editableTextState: editableTextState,
                                // Optional: specify which formatting options to include
                                // styleTypes: [StyleTypeEnum.bold, StyleTypeEnum.italic],
                              ),
                              // Keep the default context menu items
                              ...editableTextState.contextMenuButtonItems
                                  .sublist(0, 5),
                            ],
                          );
                        },
                        focusNode: _focusNode,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          // fontSize: 16,
                          // height: 1.5,
                          color: _getContrastColor(HexColor(_selectedColor)),
                        ),
                        decoration: InputDecoration(
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          fillColor: Colors.transparent,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: 'Note->New->Subtitle'.tr,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: _getContrastColor(
                              HexColor(_selectedColor),
                            ).withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.only(bottom: 24),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context, colorOptions),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isEditing) {
    final backgroundColor = HexColor(_selectedColor);
    final iconColor = _getContrastColor(backgroundColor);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: () => _confirmExit(context),
      ),
      title: Text(
        isEditing ? 'Note->Edit->Page_Title'.tr : 'Note->New->Page_Title'.tr,
        style: TextStyle(color: iconColor, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (isEditing)
          IconButton(
            icon: Icon(Icons.delete_outline, color: iconColor),
            onPressed: () => _deleteNote(context),
          ),
        IconButton(
          icon: Icon(
            _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            color: _isPinned ? AppPalette.primary : iconColor,
          ),
          onPressed: () => setState(() => _isPinned = !_isPinned),
        ),
        IconButton(
          icon: Icon(Icons.check, color: iconColor),
          onPressed: () => _saveNote(context),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    List<Map<String, dynamic>> colorOptions,
  ) {
    final backgroundColor = HexColor(_selectedColor);
    final iconColor = _getContrastColor(backgroundColor);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Note->Color_Selection'.tr,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colorOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final color = colorOptions[index];
                final isSelected = _selectedColor == color['color'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color['color']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 42 : 36,
                    height: isSelected ? 42 : 36,
                    decoration: BoxDecoration(
                      color: HexColor(color['color']),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 18,
                            color: _getContrastColor(HexColor(color['color'])),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  Future<void> _saveNote(BuildContext context) async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      Get.back();
      return;
    }

    final controller = Get.find<INoteController>();
    if (widget.note != null) {
      await controller.updateNote(
        widget.note!.id,
        _titleController.text,
        _contentController.text,
        _selectedColor,
        _isPinned,
      );
    } else {
      await controller.createNote(
        _titleController.text,
        _contentController.text,
        _selectedColor,
        _isPinned,
      );
    }
    Get.back();
  }

  Future<void> _deleteNote(BuildContext context) async {
    final confirmed = await Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Note->Delete_Note'.tr,
          style: TextStyle(color: AppPalette.primary),
        ),
        content: Text(
          'Note->Delete_Confirm_Title'.tr,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await Get.find<INoteController>().deleteNote(widget.note!.id);
      Get.back();
    }
  }

  Future<bool> _confirmExit(BuildContext context) async {
    if ((_titleController.text == (widget.note?.title ?? '')) &&
        (_contentController.text == (widget.note?.content ?? '')) &&
        (_selectedColor == _initialColor) &&
        (_isPinned == (widget.note?.isPinned ?? false))) {
      Get.back();
      return Future.value(false);
    }

    final shouldExit = await Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Note->Unsaved_Changes_Title'.tr,
          style: TextStyle(color: AppPalette.primary),
        ),
        content: Text(
          'Note->Unsaved_Changes_Subtitle'.tr,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Global->Cancel'.tr,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Global->Ignore'.tr,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      Get.back();
      return true;
    }
    return false;
  }
}
