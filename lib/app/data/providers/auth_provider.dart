import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:notes_app/app/core/constants/app_constants.dart';

import '../../core/network/api_service.dart';

class AuthProvider extends GetConnect {
  AuthProvider({String? baseUrl}) : _baseUrl = baseUrl ?? webBaseUrl;

  final String _baseUrl;

  Future<Response> login(String email, String password) =>
      post('$_baseUrl/login', {'email': email, 'password': password});

  Future<Response> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) => post('$_baseUrl/register', {
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': confirmPassword,
  });
  Future<Response> forgotPassword(String email) =>
      post('$_baseUrl/forgot-password', {'email': email});

  Future<Response> logout() async {
    final ApiService api = Get.find();
    return api.post('/logout', {});
  }

  Future<void> saveToken(String token) async {
    // Save token securely, e.g., using secure storage
    // This is a placeholder implementation
    final storage = FlutterSecureStorage();
    await storage.write(key: 'auth_token', value: token);
    // print(token);
  }

  Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    // Read token securely
    return await storage.read(key: 'auth_token');
  }

  Future<void> clearToken() async {
    final storage = FlutterSecureStorage();
    // Clear token securely
    await storage.delete(key: 'auth_token');
  }
}
