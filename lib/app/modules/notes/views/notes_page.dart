import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/note_controller.dart';

class NotesPage extends GetView<NoteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
        itemCount: controller.notes.length,
        itemBuilder: (_, i) => ListTile(title: Text(controller.notes[i].title)),
      )),
    );
  }
}