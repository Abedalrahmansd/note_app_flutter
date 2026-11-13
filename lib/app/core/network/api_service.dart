import 'package:get/get.dart';
import 'package:notes_app/app/core/constants/app_constants.dart';

import '../../data/providers/auth_provider.dart';

class ApiService extends GetConnect {
  /// [baseUrl] defaults to the real API; tests pass a local fake server.
  ApiService({String? baseUrl}) : _baseUrl = baseUrl ?? webBaseUrl;

  final String _baseUrl;
  final AuthProvider provider = AuthProvider();

  /// Called when the server rejects a request that carried a token (401), i.e.
  /// the token expired or was revoked. Set in `GlobalBinding`.
  void Function()? onUnauthorized;

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
    httpClient.addResponseModifier<dynamic>((request, response) {
      if (response.statusCode == 401 &&
          request.headers.containsKey('Authorization')) {
        onUnauthorized?.call();
      }
      return response;
    });
  }

  Future<String?> getToken() async {
    return await provider.getToken();
  }
}
