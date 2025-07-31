import 'package:get/get.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = await getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
  }

  Future<String?> getToken() async {
    return null; // Replace with secure storage read
  }
}