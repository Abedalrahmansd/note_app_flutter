import 'package:get/get.dart';
import 'package:notes_app/app/modules/settings/view/settings.dart';

import 'auth_helper.dart';

import '../../../theme/theme_controller.dart';
import '../../core/network/api_service.dart';
import '../../modules/auth/controllers/auth_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Register controllers
    Get.put(ApiService()..onUnauthorized = handleSessionExpired, permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
