import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Simple Rich Text Editor that works with existing database structure
class SimpleRichTextController extends GetxController {
  late TextEditingController textController;
  final FocusNode focusNode = FocusNode();

  // Current formatting state
  final RxBool isBold = false.obs;
  final RxBool isItalic = false.obs;
  final RxBool isUnderline = false.obs;
  final RxInt textAlignment = 0.obs; // 0: left, 1: center, 2: right
  final RxDouble fontSize = 16.0.obs;

  // Initialize with existing text
  void initialize(String? initialText) {
    textController = TextEditingController(text: initialText ?? '');
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  // Get plain text (for your existing database)
  String getPlainText() {
    return textController.text;
  }

  // Format selected text with markdown-like syntax
  void toggleBold() {
    isBold.value = !isBold.value;
    _wrapSelectedText('**', '**');
  }

  void toggleItalic() {
    isItalic.value = !isItalic.value;
    _wrapSelectedText('*', '*');
  }

  void toggleUnderline() {
    isUnderline.value = !isUnderline.value;
    _wrapSelectedText('<u>', '</u>');
  }

  void insertHeading(int level) {
    final prefix = '#' * level + ' ';
    _insertAtCursor(prefix);
  }

  void insertBulletPoint() {
    _insertAtCursor('• ');
  }

  void insertNumberedList() {
    final lines = textController.text.split('\n');
    final cursorPosition = textController.selection.start;
    final currentLineIndex =
        textController.text.substring(0, cursorPosition).split('\n').length - 1;

    if (currentLineIndex < lines.length) {
      _insertAtCursor('1. ');
    }
  }

  void _wrapSelectedText(String prefix, String suffix) {
    final selection = textController.selection;
    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = textController.text.substring(
        selection.start,
        selection.end,
      );
      final newText = textController.text.replaceRange(
        selection.start,
        selection.end,
        '$prefix$selectedText$suffix',
      );
      textController.text = newText;
      textController.selection = TextSelection.collapsed(
        offset:
            selection.start +
            prefix.length +
            selectedText.length +
            suffix.length,
      );
    } else {
      _insertAtCursor('$prefix$suffix');
      // Move cursor between the markers
      final newPosition = textController.selection.start - suffix.length;
      textController.selection = TextSelection.collapsed(offset: newPosition);
    }
    focusNode.requestFocus();
  }

  void _insertAtCursor(String text) {
    final selection = textController.selection;
    final newText = textController.text.replaceRange(
      selection.start,
      selection.end,
      text,
    );
    textController.text = newText;
    textController.selection = TextSelection.collapsed(
      offset: selection.start + text.length,
    );
    focusNode.requestFocus();
  }

  void setTextAlignment(int alignment) {
    textAlignment.value = alignment;
  }

  void setFontSize(double size) {
    fontSize.value = size;
  }
}

// Main Rich Text Editor Widget
class SimpleRichTextEditor extends StatefulWidget {
  final String? initialText;
  final Function(String)? onChanged;
  final String? hintText;
  final int? maxLines;
  final bool showToolbar;
  final SimpleRichTextController controller;

  const SimpleRichTextEditor({
    Key? key,
    this.initialText,
    this.onChanged,
    this.hintText = 'Start writing...',
    this.maxLines,
    this.showToolbar = true,
    required this.controller,
  }) : super(key: key);

  @override
  _SimpleRichTextEditorState createState() => _SimpleRichTextEditorState();
}

class _SimpleRichTextEditorState extends State<SimpleRichTextEditor> {
  // late SimpleRichTextController controller;

  @override
  void initState() {
    super.initState();
    widget.controller.initialize(widget.initialText);

    // Listen to text changes
    widget.controller.textController.addListener(() {
      widget.onChanged?.call(widget.controller.getPlainText());
    });
  }

  @override
  void dispose() {
    widget.controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Formatting Toolbar (optional)
        if (widget.showToolbar) _buildToolbar(theme),
        if (widget.showToolbar) const SizedBox(height: 12),

        // Text Editor
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
            ),
            child: Obx(
              () => TextField(
                controller: widget.controller.textController,
                focusNode: widget.controller.focusNode,
                maxLines: widget.maxLines,
                expands: widget.maxLines == null,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  fontSize: widget.controller.fontSize.value,
                  height: 1.5,
                ),
                textAlign: widget.controller.textAlignment.value == 0
                    ? TextAlign.left
                    : widget.controller.textAlignment.value == 1
                    ? TextAlign.center
                    : TextAlign.right,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.6)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // First Row: Text Formatting
          Row(
            children: [
              _ToolbarButton(
                icon: Icons.format_bold,
                tooltip: 'Bold (**text**)',
                onPressed: widget.controller.toggleBold,
              ),
              _ToolbarButton(
                icon: Icons.format_italic,
                tooltip: 'Italic (*text*)',
                onPressed: widget.controller.toggleItalic,
              ),
              _ToolbarButton(
                icon: Icons.format_underlined,
                tooltip: 'Underline (<u>text</u>)',
                onPressed: widget.controller.toggleUnderline,
              ),
              const SizedBox(width: 16),
              // Text Alignment
              Obx(
                () => _ToolbarButton(
                  icon: Icons.format_align_left,
                  isActive: widget.controller.textAlignment.value == 0,
                  tooltip: 'Align Left',
                  onPressed: () => widget.controller.setTextAlignment(0),
                ),
              ),
              Obx(
                () => _ToolbarButton(
                  icon: Icons.format_align_center,
                  isActive: widget.controller.textAlignment.value == 1,
                  tooltip: 'Align Center',
                  onPressed: () => widget.controller.setTextAlignment(1),
                ),
              ),
              Obx(
                () => _ToolbarButton(
                  icon: Icons.format_align_right,
                  isActive: widget.controller.textAlignment.value == 2,
                  tooltip: 'Align Right',
                  onPressed: () => widget.controller.setTextAlignment(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Second Row: Structure & Size
          Row(
            children: [
              _ToolbarButton(
                icon: Icons.title,
                tooltip: 'Heading 1 (# text)',
                onPressed: () => widget.controller.insertHeading(1),
              ),
              _ToolbarButton(
                icon: Icons.text_fields,
                tooltip: 'Heading 2 (## text)',
                onPressed: () => widget.controller.insertHeading(2),
              ),
              _ToolbarButton(
                icon: Icons.format_list_bulleted,
                tooltip: 'Bullet Point',
                onPressed: widget.controller.insertBulletPoint,
              ),
              _ToolbarButton(
                icon: Icons.format_list_numbered,
                tooltip: 'Numbered List',
                onPressed: widget.controller.insertNumberedList,
              ),
              const Spacer(),
              // Font Size
              Icon(Icons.format_size, size: 16, color: theme.hintColor),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: Obx(
                  () => Slider(
                    value: widget.controller.fontSize.value,
                    min: 12,
                    max: 20,
                    divisions: 4,
                    onChanged: widget.controller.setFontSize,
                  ),
                ),
              ),
              Obx(
                () => Text(
                  '${widget.controller.fontSize.value.toInt()}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Toolbar Button Widget
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isActive;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 4),
        child: Material(
          color: isActive
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isActive
                    ? Border.all(color: theme.primaryColor.withOpacity(0.3))
                    : null,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isActive
                    ? theme.primaryColor
                    : theme.iconTheme.color?.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Preview Widget to show formatted text
class FormattedTextPreview extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;

  const FormattedTextPreview({
    Key? key,
    required this.text,
    this.fontSize = 16.0,
    this.textAlign = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(textAlign: textAlign!, text: _buildTextSpan(text, context));
  }

  TextSpan _buildTextSpan(String text, BuildContext context) {
    final theme = Theme.of(context);
    final List<TextSpan> spans = [];

    // Simple markdown-like parsing
    final RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
    final RegExp italicRegex = RegExp(r'\*(.*?)\*');
    final RegExp underlineRegex = RegExp(r'<u>(.*?)</u>');
    final RegExp headingRegex = RegExp(r'^(#{1,3})\s(.+)$', multiLine: true);

    String processedText = text;

    // Replace formatting with styled text
    processedText = processedText.replaceAllMapped(boldRegex, (match) {
      return match.group(1) ?? '';
    });

    return TextSpan(
      text: processedText,
      style: TextStyle(
        fontSize: fontSize,
        color: theme.textTheme.bodyLarge?.color,
        height: 1.5,
      ),
    );
  }
}

// Usage Example
class RichTextEditorDemo extends StatefulWidget {
  final SimpleRichTextController controller;
  const RichTextEditorDemo({super.key, required this.controller});
  @override
  _RichTextEditorDemoState createState() => _RichTextEditorDemoState();
}

class _RichTextEditorDemoState extends State<RichTextEditorDemo> {
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rich Text Editor Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // This is what you'd save to your existing database
              print('Saving content: $_content');
              Get.snackbar('Saved!', 'Content saved to database');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SimpleRichTextEditor(
          initialText:
              'Welcome to the Rich Text Editor!\n\n**Try making text bold**\n*Or italic*\n<u>Even underlined</u>\n\n# This is a heading\n## Smaller heading\n\n• Bullet point\n• Another point',
          onChanged: (content) {
            setState(() {
              _content = content;
            });
          },
          hintText: 'Start writing your note...',
          controller: widget.controller,
        ),
      ),
      // Optional: Preview button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            Dialog(
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 500,
                ),
                child: Column(
                  children: [
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    Expanded(child: FormattedTextPreview(text: _content)),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.preview),
      ),
    );
  }
}
