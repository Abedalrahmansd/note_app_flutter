import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/app/modules/notes/controllers/implementations/i_note_controller.dart';
import 'package:note_app/theme/theme_controller.dart';
import '../../../../theme/app_theme.dart';
import '../../../data/models/note_model.dart';
import 'package:hexcolor/hexcolor.dart';

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
  late bool _isPinned;
  final _focusNode = FocusNode();
  final themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedColor =
        widget.note?.color ??
        (themeController.currentTheme.value == AppTheme.darkTheme
            ? AppPalette.noteColors
                  .where((c) => c['name'] == 'Black')
                  .first['color']
            : AppPalette.noteColors
                  .where((c) => c['name'] == 'White')
                  .first['color']);
    _isPinned = widget.note?.isPinned ?? false;

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
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _titleController,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: _getContrastColor(HexColor(_selectedColor)),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: TextStyle(
                            color: _getContrastColor(
                              HexColor(_selectedColor),
                            ).withOpacity(0.5),
                          ),
                          contentPadding: const EdgeInsets.only(bottom: 12),
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _contentController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          color: _getContrastColor(HexColor(_selectedColor)),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Start typing...',
                          hintStyle: TextStyle(
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
        isEditing ? 'Edit Note' : 'New Note',
        style: TextStyle(color: iconColor),
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
                'Note Color',
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
        title: Text('Delete Note', style: TextStyle(color: AppPalette.primary)),
        content: const Text(
          'Are you sure you want to permanently delete this note?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
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
        (_selectedColor ==
            (widget.note?.color ??
                AppPalette.primary.value.toRadixString(16))) &&
        (_isPinned == (widget.note?.isPinned ?? false))) {
      Get.back();
      return Future.value(false);
    }

    final shouldExit = await Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Discard Changes?',
          style: TextStyle(color: AppPalette.primary),
        ),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('DISCARD', style: TextStyle(color: Colors.red)),
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
