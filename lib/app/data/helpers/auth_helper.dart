import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<bool> isLoggedIn() async {
  final token = await storage.read(key: 'auth_token');
  return token != null && token.isNotEmpty;
}
