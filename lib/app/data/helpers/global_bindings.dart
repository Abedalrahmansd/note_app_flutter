import 'package:get/get.dart';

import '../../../theme/theme_controller.dart';
import '../../core/network/api_service.dart';
import '../../modules/auth/controllers/auth_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Register controllers
    Get.put(ApiService(),permanent: true);
    Get.put(ThemeController(),permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
