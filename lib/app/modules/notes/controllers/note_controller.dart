import 'package:get/get.dart';
import 'package:note_app/app/data/providers/auth_provider.dart';

import '../../../data/models/note_model.dart';

class NoteController extends GetxController {
  final notes = <NoteModel>[].obs;
  final provider = NoteProvider();

  @override
  void onInit() {
    fetchNotes();
    super.onInit();
  }

  void fetchNotes() async {
    final response = await provider.getNotes();
    if (response.isOk) {
      notes.assignAll(response.body ?? []);
    }
  }
}