import 'package:get/get.dart';

import 'controllers/implementations/i_note_controller.dart';
import 'controllers/note_controller.dart';
import 'controllers/offline_note_controller.dart';

class NotesBinding extends Bindings {
  final bool isOffline;

  NotesBinding({required this.isOffline});

  @override
  void dependencies() {
    if (isOffline) {
      Get.lazyPut<INoteController>(() => OfflineNoteController());
    } else {
      Get.lazyPut<INoteController>(() => NoteController());
    }
  }
}
