import 'package:get/get.dart';
import '../../core/network/api_service.dart';
import '../models/note_model.dart';

class NoteProvider extends GetConnect {
  final ApiService api = Get.find<ApiService>();
  Future<Response<List<NoteModel>>> getNotes() async => api.get(
    '/notes',
    decoder: (data) =>
        (data['data'] as List).map((e) => NoteModel.fromJson(e)).toList(),
  );

  Future<Response<NoteModel>> createNote(Map<String, dynamic> body) {
    return api.post(
      '/notes',
      body,
      decoder: (data) =>
          NoteModel.fromJson(data['data']), // Laravel returns wrapped response
    );
  }

  Future<Response<NoteModel>> updateNote(int id, Map<String, dynamic> body) {
    return api.post(
      '/notes/$id',
      body,
      decoder: (data) => NoteModel.fromJson(data['data']),
    );
  }

  Future<Response> deleteNote(int id) {
    return api.delete('/notes/$id');
  }
}
