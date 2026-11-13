import 'package:get/get.dart';
import '../../core/network/api_service.dart';

/// Thin wrapper over the notes REST API.
///
/// Methods return the raw [Response] (body already JSON-decoded). The controller
/// turns a successful body into a `NoteModel` with `NoteModel.fromEnvelope`;
/// for failures it reads the server's message from the same body (401 / 422 /
/// 500 ...). Decoding inside the provider used to throw on those error bodies.
class NoteProvider extends GetConnect {
  final ApiService api = Get.find<ApiService>();

  Future<Response> getNotes() => api.get('/notes');

  Future<Response> createNote(Map<String, dynamic> body) =>
      api.post('/notes', body);

  Future<Response> updateNote(int id, Map<String, dynamic> body) =>
      api.post('/notes/$id', body);

  Future<Response> deleteNote(int id) => api.delete('/notes/$id');

  Future<Response> pinNote(int id) => api.post('/notes/$id/pin', {});

  Future<Response> unpinNote(int id) => api.post('/notes/$id/unpin', {});

  Future<Response> archiveNote(int id) => api.post('/notes/$id/archive', {});

  Future<Response> unarchiveNote(int id) =>
      api.post('/notes/$id/unarchive', {});

  Future<Response> markDeleted(int id) => api.post('/notes/$id/mark-deleted', {});

  Future<Response> addTags(int id, List<String> tags) =>
      api.post('/notes/$id/tags', {'tags': tags});

  Future<Response> removeTags(int id, List<String> tags) =>
      api.post('/notes/$id/tags/remove', {'tags': tags});

  // uncompleted backend
  // Future<Response> changeCategory(int id, int categoryId) =>
  //     api.post('/notes/$id/category', {'category_id': categoryId});

  Future<Response> changeColor(int id, String color) =>
      api.post('/notes/$id/color', {'color': color});

  Future<Response> changeStatus(int id, String status) =>
      api.post('/notes/$id/status', {'status': status});
}
