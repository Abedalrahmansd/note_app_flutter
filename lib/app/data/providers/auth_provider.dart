import 'package:get/get.dart';

import '../models/note_model.dart';


class NoteProvider extends GetConnect {
  Future<Response<List<NoteModel>>> getNotes() =>
    get('$baseUrl/notes',
        decoder: (data) => (data as List).map((e) => NoteModel.fromJson(e)).toList());

  Future<Response<NoteModel>> createNote(Map<String, dynamic> body) =>
    post('$baseUrl/notes', body, decoder: (data) => NoteModel.fromJson(data));
}