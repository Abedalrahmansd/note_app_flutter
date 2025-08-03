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

  Future<Response<NoteModel>> pinNote(int id) {
    return api.post(
      '/notes/$id/pin',
      {},
      decoder: (data) => NoteModel.fromJson(data['data']),
    );
  }

  Future<Response<NoteModel>> unpinNote(int id) {
    return api.post(
      '/notes/$id/unpin',
      {},
      decoder: (data) => NoteModel.fromJson(data['data']),
    );
  }

  Future<Response<NoteModel>> archiveNote(int id) {
    return api.post(
      '/notes/$id/archive',
      {},
      decoder: (data) => NoteModel.fromJson(data['data']),
    );
  }

  Future<Response<NoteModel>> unarchiveNote(int id) {
    return api.post(
      '/notes/$id/unarchive',
      {},
      decoder: (data) => NoteModel.fromJson(data['data']),
    );
  }

  Future<Response<NoteModel>> markDeleted(int id) {
    return api.post(
      '/notes/$id/mark-deleted',
      {},
      decoder: (data) => NoteModel.fromJson(data['data']),
    );
  }

  Future<Response<NoteModel>> addTags(int id, List<String> tags) {
    return api.post('/notes/$id/tags', {
      'tags': tags,
    }, decoder: (data) => NoteModel.fromJson(data['data']));
  }

  Future<Response<NoteModel>> removeTags(int id, List<String> tags) {
    return api.post('/notes/$id/tags/remove', {
      'tags': tags,
    }, decoder: (data) => NoteModel.fromJson(data['data']));
  }
  //uncompleted backend
  /* Future<Response<NoteModel>> changeCategory(int id, int categoryId) {
    return api.post(
      '/notes/$id/category',
      {'category_id': categoryId},
      decoder: (data) => NoteModel.fromJson(data['data']),
    );
  } */
  //

  Future<Response<NoteModel>> changeColor(int id, String color) {
    return api.post('/notes/$id/color', {
      'color': color,
    }, decoder: (data) => NoteModel.fromJson(data['data']));
  }

  Future<Response<NoteModel>> changeStatus(int id, String status) {
    return api.post('/notes/$id/status', {
      'status': status,
    }, decoder: (data) => NoteModel.fromJson(data['data']));
  }
}
