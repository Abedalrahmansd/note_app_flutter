import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../core/exceptions/api_exception.dart';
import '../../modules/notes/bindings.dart';
import '../../modules/notes/controllers/implementations/i_note_controller.dart';
import '../../modules/notes/views/notes_page.dart';
import '../../routes/app_routes.dart';
import '../providers/auth_provider.dart';

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


bool _handlingExpiredSession = false;

/// The server rejected our token (expired / revoked): forget it and send the
/// user back to the start screen instead of leaving a screen that fails silently.
Future<void> handleSessionExpired() async {
  if (_handlingExpiredSession) return;
  _handlingExpiredSession = true;
  try {
    await AuthProvider().clearToken();
    await storage.write(key: 'is_offline', value: 'false');
    Get.offAllNamed(AppRoutes.CONNECTION_CHOICE);
    Get.delete<INoteController>(force: true);
    showApiMessage('Api->Session_Expired'.tr);
  } finally {
    _handlingExpiredSession = false;
  }
}
