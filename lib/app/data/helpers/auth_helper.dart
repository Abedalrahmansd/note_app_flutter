import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../modules/notes/bindings.dart';
import '../../modules/notes/views/notes_page.dart';
import '../../routes/app_routes.dart';

final storage = FlutterSecureStorage();

Future<bool> isLoggedIn() async {
  final token = await storage.read(key: 'auth_token');
  return token != null && token.isNotEmpty;
}

void checkAuth() async {
  final loggedIn = await isLoggedIn();
  if (loggedIn) {
    Get.offAll(
      () => NotesPage(),
      binding: NotesBinding(isOffline: false),
      routeName: AppRoutes.NOTES,
    );
    return;
  } else if (await isOfflineMode()) {
    Get.offAll(
      () => NotesPage(),
      binding: NotesBinding(isOffline: true),
      routeName: AppRoutes.NOTES,
    );
    return;
  }
  Get.offAllNamed(AppRoutes.CONNECTION_CHOICE);
}

Future<bool> isOfflineMode() async {
  final isOffline = await storage.read(key: 'is_offline');
  if (isOffline == 'true') {
    return true;
  }
  return false;
}
