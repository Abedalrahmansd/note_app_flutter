import 'package:get/get.dart';
import 'package:note_app/app/core/constants/app_constants.dart';

import '../../data/providers/auth_provider.dart';

class ApiService extends GetConnect {
  final AuthProvider provider = AuthProvider();
  @override
  void onInit() {
    httpClient.baseUrl = webBaseUrl;
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = await getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }

  Future<String?> getToken() async {
    return await provider.getToken();
  }
}