import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  Future<Response> login(String email, String password) =>
      post('$baseUrl/login', {'email': email, 'password': password});

  Future<Response> register(String name, String email, String password) => post(
    '$baseUrl/register',
    {'name': name, 'email': email, 'password': password},
  );
}
